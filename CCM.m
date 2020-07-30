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
dss = zeros((len_s)^2,len_s);
s_horz = [s,zeros(len_s,len_s-1)];
s_vert = conj(s_horz');
s_horz = s_horz * (1+1i);
s_vert = s_vert * (1-1i);
roujia_loop_ans = zeros(len_s^2,len_s);
roujia_loop_I = eye(len_s);
roujia_v2 = zeros(len_s,len_s);
beta = 0.1;
iterDiff = 1;
iter = 1;
epsilon = 1e-5;
end_iter = 100;
sinr = zeros(end_iter,1);
time = zeros(end_iter,1);
while (iterDiff>epsilon) && (iter <= (end_iter))
    %disp(iterDiff);
    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    fPre = obj_func(s,A0,phi_S,eye(N*Nr));
    % step 1 gradient
    first_term = 2 * real((A0' / (phi_S + eye(len_s)) * A0) * s);
    for k = 1 : len_s
        J = eye(len_s,len_s);
        dss(len_s*(k-1)+1:len_s*k,:) = s_horz * circshift(J,(k-1),2) + circshift(J,(k-1),1) * s_vert;
        dss(k+len_s*(k-1),k) = 2 * (real(s(k))+imag(s(k)));
    end
    for k = 1:K  
        roujia_loop_1 = Ak(:,:,k);
        roujia_loop_ans = roujia_loop_ans + q(k) * kron(roujia_loop_I,Ak(:,:,k)) * dss * ctranspose(roujia_loop_1);
    end
    roujia_v1 = (phi_S+eye(len_s)) \ A0 * s;
    roujia_vec = repmat(ctranspose(roujia_v1),[1,len_s]);
    roujia_v3 = ctranspose(s) * ctranspose(A0) / (phi_S + eye(len_s));
    for k = 1:len_s
        roujia_v2(k,:) = roujia_v3 * roujia_loop_ans(len_s*(k-1)+1:len_s*k,:);
    end
    last_term = roujia_v2 * roujia_v1;
    df = (first_term + last_term);
    
    delta_s = 0.01 * rand(len_s,1);
    s_new = s + delta_s;
    S_new = s_new*s_new';
    phi_S_new = phi(S_new,K,Ak,q,theta,N,Nr);
    f_new = obj_func(s_new,A0,phi_S_new,eye(N*Nr));
    
    f_new_d = fPre - delta_s' * df;
    
    change_scale = (abs(f_new_d-fPre) - abs(f_new-fPre))/abs(f_new-fPre)
    
    %step2 project to tangent space
    Proj = df - real(conj(df) .* s) .* s;
    
    % step 3 gradient decent
    s = s + beta * Proj;
    
    % step 4 retraction
    s = s ./ abs(s);
    

    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    f = obj_func(s,A0,phi_S,eye(N*Nr));
    iterDiff = norm(f - fPre);

    
    temp = (phi_S + eye(N*Nr));
    filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);
    sinr(iter) = SINR(filter,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v);
    time(iter) = cputime - t0;
    if iter == end_iter || iterDiff <= epsilon
        figure(1)
        plot(time(1:iter-1),sinr(1:iter-1));
        xlabel('CPU time(s)');
        ylabel('SINR(dB)')
    end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);