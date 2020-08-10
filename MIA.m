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

end_iter = 2000;
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

%Similarity Constraint
if SimiCon
    Simi_epsilon0 = 0.5 / sqrt(N*Nt);
    Simi_epsilon = sqrt(N*Nt) * Simi_epsilon0;% [0,2]
    Simi_delta = 2 * acos(1 - Simi_epsilon^2 / 2);
    Simi_gamma = angle(s0) - Simi_delta / 2;
end

%Peak-to-Average Constraint
if PAR
    PAR_gamma = N;
    PAR_N = N*Nt;
end

len_s = N*Nt;
change = 10;
epsilon = 1e-5;
iter = 1;
while change > epsilon && iter <= (end_iter)
    S = s*s';
    phi_S = phi(S,K,Ak,q,theta,N,Nr);
    f_k = obj_func(s,A0,phi_S,eye(N*Nr));
    

    z = A0'/(phi_S+eye(N*Nr))*A0*s; %N*Nt ¡Á 1

    P = zeros(len_s,len_s);
    for k = 1:K  
        Q = A0'/(phi_S+eye(N*Nr))*Ak(:,:,k);
        P = P + q(k) * Q' * S * Q;
    end
    
    lambda = trace(P);
    v = 2 * (P - lambda * eye(len_s,len_s)) * s - z;
    
    
    if SimiCon
        Simi_phi_opt = zeros(len_s,1);
        Simi_phi = angle(-v);
        for i = 1 : len_s
            if Simi_gamma(i) < (Simi_phi(i)) && Simi_gamma(i)+Simi_delta > (Simi_phi(i))
                Simi_phi_opt(i) = (Simi_phi(i));
            elseif real(conj(v(i)) * exp(1i * (Simi_gamma(i)+Simi_delta))) > real(conj(v(i)) * exp(1i * Simi_gamma(i)))
                Simi_phi_opt(i) = Simi_gamma(i);
            else
                Simi_phi_opt(i) = Simi_gamma(i)+Simi_delta;
            end
        end
        s =  exp(1i*Simi_phi_opt) ;
    elseif PAR
        PAR_m = sum(v~=0);
        if PAR_m * PAR_gamma <= len_s
            s(v~=0) = - sqrt(PAR_gamma) * exp(1i*angle(v(v~=0)));
            s(v==0) = - sqrt((len_s - PAR_m * PAR_gamma)/(len_s - PAR_m)) * exp(1i*angle(v(v==0)));
        else
            PAR_left = 0;
            PAR_right = sqrt(PAR_gamma)/min(abs(v(v~=0)));
            PAR_sum = 0;
            while abs(PAR_sum - PAR_N) > 0.3
                PAR_mid = PAR_left + (PAR_right - PAR_left) / 2;
                PAR_beta = PAR_mid;
                PAR_ind1 = PAR_beta^2 * abs(v).^2 > PAR_gamma;
                PAR_sum = PAR_beta^2 * sum(abs(v(~PAR_ind1)).^2) + sum(PAR_ind1) * PAR_gamma;
                if PAR_sum > PAR_N
                    PAR_right = PAR_mid;
                elseif PAR_sum < PAR_N
                    PAR_left = PAR_mid;
                else
                    break;
                end
            end
            PAR_ind2 = PAR_beta * abs(v) > PAR_gamma;
            s(PAR_ind2) = - sqrt(PAR_gamma) * exp(1i*angle(v(PAR_ind2)));
            s(~PAR_ind2) = - PAR_beta * abs(v(~PAR_ind2)) .* exp(1i*angle(v(~PAR_ind2)));
        end
    else
        s = - exp(1i*angle(v)) ;
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
        plot(time(1:iter-1),sinr(1:iter-1));
        xlabel('CPU time(s)');
        ylabel('SINR(dB)')
    end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);


