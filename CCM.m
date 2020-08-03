clc;clear;
t0 = cputime;
Nt = 8;
Nr = 8;
N = 8;
K = 3;
sigma_0 = 1;
sigma_k = [0.5,0.2,0.3];
sigma_v = 0.001;
q = sigma_k / sigma_v;
rk = [0,1,2];
r0 = 0;
theta0 = 15;
theta = [-50,-10,40];
s_init = zeros(Nt,N);

evaluation = 0;

rho = 0.45;
sigma = 0.1;
tau = 0.1;%Armijo parameters


for k = 1:Nt
    for n = 1:N
        s_init(k,n) = exp(1i * 2 * pi * (n - 1) * (k + n - 1) / N);
    end
end

% initial f
s = s_init(:);
A0 = A(theta0,r0,N,Nr,Nt);
Ak = zeros(N*Nr,N*Nt,K);
for k = 1:K  
    Ak(:,:,k) = A(theta(k),rk(k),N,Nr,Nt);
end


len_s = N*Nt;
dss = zeros(len_s,len_s);
% s_horz = s_horz * (1+1i);
% s_vert = s_vert * (1-1i);
roujia_loop_ans = zeros(len_s,len_s);
roujia_v2 = zeros(len_s,len_s);
beta = 0.005;
iterDiff = 1;
iter = 1;
epsilon = 1e-15;
end_iter = 80;
sinr = zeros(end_iter,1);
time = zeros(end_iter,1);
func = zeros(end_iter,1);
while (iterDiff>epsilon) && (iter <= (end_iter))
    %disp(iterDiff);
    phi_S = phi(s*s',K,Ak,q,theta,N,Nr);
    fPre = obj_func(s,A0,phi_S,eye(N*Nr));
    % step 1 gradient
    df = fun_grad( s, A0,phi_S,K,q,Ak );
    
    % evaluation
    if evaluation == 1
        delta_s = 0.01 * rand(len_s,1);
        s_new = s + delta_s;
        S_new = s_new*s_new';
        phi_S_new = phi(S_new,K,Ak,q,theta,N,Nr);
        f_new = obj_func(s_new,A0,phi_S_new,eye(N*Nr));

        f_new_d = fPre + delta_s' * df;

        change_scale(iter) = (abs(f_new_d-fPre) - abs(f_new-fPre))/abs(f_new-fPre)
    end
    
    %step2 project to tangent space
    Proj = df - real(conj(df) .* s) .* s;
    
    % step 3 gradient decent
    mk = armijo(s, rho, sigma, df,A0,phi_S,eye(N*Nr),K,q,Ak,Proj,tau);
    s = s + tau * rho^mk * Proj;
    
    % step 4 retraction
    s = s ./ abs(s);
    
    
    phi_S = phi(s*s',K,Ak,q,theta,N,Nr);
    f = obj_func(s,A0,phi_S,eye(N*Nr));
    iterDiff = norm(f - fPre);

    
    temp = (phi_S + eye(N*Nr));
    filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);
    func(iter) = f;
    sinr(iter) = SINR(filter,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v);
    time(iter) = cputime - t0;

    if iter == end_iter || iterDiff <= epsilon
        figure(1)
        if evaluation == 1
            change_scale(:) = (change_scale-min(change_scale))/(max(change_scale)-min(change_scale))*5+34;
            plot(time(1:iter-1),sinr(1:iter-1),time(1:iter-1),change_scale(1:iter-1));
        end
        if evaluation == 0
            plot(time(1:iter-1),sinr(1:iter-1));
        end
        xlabel('CPU time(s)');
        ylabel('SINR(dB)')
%         figure(2)
%         plot(time(1:iter-1),func(1:iter-1));
    end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);