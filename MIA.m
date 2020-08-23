clc;clear;
t0 = cputime;
Nt = 10;
Nr = 10;
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
SimiCon = false;
PAR = false;
e_Uncertain = false;
proj.SimiCon.value = true;
proj.PAR.value = false;
proj.e.value = false;

acceleration = false;

end_iter = 2000;
sinr = zeros(end_iter,1);
time = zeros(end_iter,1);
for k = 1:Nt
    for n = 1:N
            s_init(k,n) = exp(1i * 2 * ...
                pi * (n - 1) * (k + n - 1) / N) ;
    end
end
s0 = s_init(:);
S = s0*s0';
A0 = A(theta0,r0,N,Nr,Nt);
Ak = zeros(N*Nr,N*Nt,K);
for k = 1:K  
    Ak(:,:,k) = A(theta(k),rk(k),N,Nr,Nt);
end

phi_S = phi(S,K,Ak,q,theta,N,Nr);
s = s0;

%Similarity Constraint
if proj.SimiCon.value
    proj.SimiCon.epsilon0 = 0.5 / sqrt(N*Nt);
    proj.SimiCon.epsilon = sqrt(N*Nt) * proj.SimiCon.epsilon0;% [0,2]
    proj.SimiCon.delta = 2 * acos(1 - proj.SimiCon.epsilon^2 / 2);
    proj.SimiCon.gamma = angle(s0) - proj.SimiCon.delta / 2;
end

%Peak-to-Average Constraint
if proj.PAR.value
    proj.PAR.gamma = N;
    proj.PAR.N = N*Nt;
end

%e-Uncertainty Constant Modulus Constraint 
if proj.e.value
    proj.e.ce2 = N*Nt;
    proj.e.cm = N;
    proj.e.e1 = 7.5;
    proj.e.e2 = 1;
    assert(N * Nt * (proj.e.cm -...
        proj.e.e1)^2 <= proj.e.ce2 && proj.e.ce2 <=...
        N * Nt * (proj.e.cm +proj.e.e2)^2,'out of range');
end

len_s = N*Nt;
change = 10;
epsilon = 1e-4;
iter = 1;
while change > epsilon && iter <= (end_iter)
    if acceleration
        acc_s = s;
    end
    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    f_k = obj_func(s,A0,phi_S,eye(N*Nr));
    

    z = A0'/(phi_S+eye(N*Nr))*A0*s; %N*Nt �� 1

    P = zeros(len_s,len_s);
    for k = 1:K  
        Q = A0'/(phi_S+eye(N*Nr))*Ak(:,:,k);
        P = P + q(k) * Q' * S * Q;
    end
    
    lambda = trace(P);
    v = 2 * (P - lambda * eye(len_s,len_s)) * s - z;
    
    % Projection
    s = proj_to(proj,v);
    
    if acceleration
        z = A0'/(phi_S+eye(N*Nr))*A0*s; %N*Nt �� 1
        P(:,:) = 0;
        Q(:,:) = 0;
        for k = 1:K  
            Q = A0'/(phi_S+eye(N*Nr))*Ak(:,:,k);
            P = P + q(k) * Q' * S * Q;
        end
        lambda = trace(P);
        v = 2 * (P - lambda * eye(len_s,len_s)) * s - z;
        acc_s2 = proj_to(proj,v);
        
        acc_r = s - acc_s;
        acc_v = acc_s2 - s - acc_r;
        acc_alpha = - norm(acc_r)/norm(acc_v);
        acc_res = proj_to(proj,acc_s - 2 * acc_alpha *...
            acc_r + acc_alpha^2 * acc_v);
        
        S = acc_res*acc_res';
        phi_S = phi(S,K,Ak,q,theta,N,Nr);
        acc_f = obj_func(acc_res,A0,phi_S,eye(N*Nr));
        
        while real(acc_f) > real(f_k)
            acc_alpha = (acc_alpha - 1) / 2;
            acc_res = proj_to(proj,acc_s - 2 * acc_alpha *...
            acc_r + acc_alpha^2 * acc_v);
        end
        
        s = acc_res;
    end
    
    
    
    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    f_new = obj_func(s,A0,phi_S,eye(N*Nr));
    
    change = abs(f_k - f_new);
    
    temp = (phi_S + eye(N*Nr));
    filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);
    sinr(iter) = SINR(filter,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v);
    time(iter) = cputime - t0;
    if iter == end_iter || change <= epsilon
            figure(1)
            hold on
            plot(1:100,sinr(1:100),'r:');
            xlabel('Iterations');
            ylabel('SINR(dB)')
            hold off
            saveas(gcf,'test.eps','psc2')
            figure(2)
            hold on
            plot(time(1:iter-1),sinr(1:iter-1),'r:');
            xlabel('CPU time(s)');
            ylabel('SINR(dB)')
            hold off
            saveas(gcf,'test.eps','psc2')
    end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);


