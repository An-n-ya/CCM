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

end_iter = 6000;
sinr = zeros(end_iter,1);
time = zeros(end_iter,1);
for k = 1:Nt
    for n = 1:N
        s_init(k,n) = exp(1i * 2 * pi * (n - 1) * (k + n - 1) / N) ;
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

change = 10;
epsilon = 1e-5;
iter = 1;
while change > epsilon && iter <= (end_iter)
    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    f_k = obj_func(s,A0,phi_S,eye(N*Nr));
    

    z = A0'/(phi_S+eye(N*Nr))*A0*s; %N*Nt ¡Á 1

    P = zeros(N*Nt,N*Nt);
    for k = 1:K  
        Q = A0'/(phi_S+eye(N*Nr))*Ak(:,:,k);
        P = P + q(k) * Q' * S * Q;
    end
    
    lambda = trace(P);
    v = 2 * (P - lambda * eye(N*Nt,N*Nt)) * s - z;
    s = - exp(1i*angle(v)) ;
    
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
        plot(time(1:iter-1),sinr(1:iter-1));
        xlabel('CPU time(s)');
        ylabel('SINR(dB)')
    end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);


