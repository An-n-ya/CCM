function s = CCM(mode)
t0 = cputime;
Nt = 10;
Nr = 10;
N = 8;
K = 3;
sigma_0 = 100;
%sigma_k = [0.5,0.2,0.3];
sigma_k = [100,100,100];
sigma_v = 1;
%sigma_v = 0.8;
q = sigma_k / sigma_v;
rk = [0,1,2];
r0 = 0;
theta0 = 15;
theta = [-50,-10,40];
s_init = zeros(Nt,N);

% switch mode
evaluation = 0;
SimiCon = mode.SimiCon;
PAR = mode.PAR;
e_Uncertain = mode.e;

acceleration = mode.acceleration;

%Armijo parameters
rho = 0.85;
sigma = 0.1;
tau = 1;
if PAR || e_Uncertain
    rho = 0.85;
    sigma = 0.1;
    tau = 0.4;
end

% initial s
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

%Similarity Constraint
if SimiCon
    Simi_epsilon0 = 0.5 / sqrt(N*Nt);
    Simi_epsilon = sqrt(N*Nt) * Simi_epsilon0;% [0,2]
    Simi_delta = 2 * acos(1 - Simi_epsilon^2 / 2);
    Simi_gamma = angle(s) - Simi_delta / 2;
end
%Peak-to-Average Constraint
if PAR
    PAR_gamma = N;
    PAR_N = N*Nt;
end
%e-Uncertainty Constant Modulus Constraint 
if e_Uncertain
    e_ce2 = N*Nt;
    e_cm = N;
    e_e1 = 7.5;
    e_e2 = 1;
    assert(N * Nt * (e_cm - e_e1)^2 <= e_ce2...
        && e_ce2 <= N * Nt * (e_cm + e_e2)^2,'out of range');
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
epsilon = 1e-4;
end_iter = 150;
sinr = zeros(end_iter,1);
time = zeros(end_iter,1);
func = zeros(end_iter,1);
while (iterDiff>epsilon) && (iter <= (end_iter))
    %disp(iterDiff);
    phi_S = phi(s*s',K,Ak,q,theta,N,Nr);
    fPre = obj_func(s,A0,phi_S,eye(N*Nr));
    % step 1 gradient
    df = fun_grad_mex( s, A0,phi_S,K,q,Ak );
        
    %step2 project to tangent space
    Proj = df - real(conj(df) .* s) .* s;
    
    % step 3 gradient decent
    if acceleration
         mk = armijo(s, rho, sigma, df,A0,phi_S,eye(N*Nr),K,q,Ak,Proj,tau);
         s = s + tau * rho^mk * Proj;
    else
         s = s+0.1*Proj;
    end
    
    % evaluation
    if evaluation == 1
        %delta_s = 0.01 * rand(len_s,1);
        %s_new = s + delta_s;
        S_new = s*s';
        phi_S_new = phi(S_new,K,Ak,q,theta,N,Nr);
        f_new = obj_func(s,A0,phi_S_new,eye(N*Nr));
        
        s_2 = s ./ abs(s);
        S_2 = s_2*s_2';
        phi_S_2 = phi(S_2,K,Ak,q,theta,N,Nr);
        f_2 = obj_func(s_2,A0,phi_S_2,eye(N*Nr));
        
        f_new - f_2

        %f_new_d = fPre + delta_s' * df;

        %change_scale(iter) = (abs(f_new_d-fPre) - abs(f_new-fPre))/abs(f_new-fPre)
    end
    %s = s + 0.01 * df;
    % step 4 retraction
    v = s;
    if SimiCon
        Simi_phi_opt = zeros(N*Nt,1);
        Simi_phi = angle(v);
%          Simi_ind = (Simi_gamma <= Simi_phi) & ((Simi_gamma+Simi_delta) >= Simi_phi);
%          Simi_ind2 = ~Simi_ind & abs(wrapToPi(angle(v) - Simi_gamma-Simi_delta)) > abs(wrapToPi(angle(v) - Simi_gamma));
%          Simi_ind3 = ~Simi_ind & ~Simi_ind2;
%          Simi_phi_opt(Simi_ind) = Simi_phi(Simi_ind);
%          Simi_phi_opt(Simi_ind2) = Simi_gamma(Simi_ind2);
%          Simi_phi_opt(Simi_ind3) = Simi_gamma(Simi_ind3)+Simi_delta;
        for i = 1 : N * Nt
            theta_low = Simi_gamma(i);
            theta_high = Simi_gamma(i)+Simi_delta;
            if theta_low <= (Simi_phi(i)) && theta_high >= (Simi_phi(i))
                Simi_phi_opt(i) = (Simi_phi(i));
            elseif abs(wrapToPi(angle(v(i)) - theta_high)) > abs(wrapToPi(angle(v(i)) - theta_low))
                Simi_phi_opt(i) = theta_low;
            else
                Simi_phi_opt(i) = theta_high;
            end
        end
            s =  exp(1i*Simi_phi_opt) ;
    elseif PAR
        PAR_m = sum(v~=0);
        if PAR_m * PAR_gamma <= len_s
            s(v~=0) = sqrt(PAR_gamma) * exp(1i*angle(v(v~=0)));
            s(v==0) = sqrt((len_s - PAR_m * PAR_gamma)/(len_s - PAR_m)) * exp(1i*angle(v(v==0)));
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
            s(PAR_ind2) = sqrt(PAR_gamma) * exp(1i*angle(v(PAR_ind2)));
            s(~PAR_ind2) = PAR_beta * abs(v(~PAR_ind2)) .* exp(1i*angle(v(~PAR_ind2)));
        end 
    elseif e_Uncertain
        e_ind = v~=0;
        e_m = sum(e_ind);
        e_plus = (e_cm+e_e2)^2;
        e_minus = (e_cm-e_e1)^2;
        if e_m * e_plus + (len_s - e_m) * e_minus <= e_ce2 &&...
                e_ce2 <= len_s * e_plus
            s(e_ind) = (e_cm + e_e2) * exp(1i*angle(v(PAR_ind2)));
            s(~e_ind) = sqrt((e_ce2-e_m * e_plus) /...
                (len_s - e_m)) * exp(1i*angle(v(~PAR_ind2)));
        elseif len_s * e_minus <= e_ce2 &&...
                e_ce2 <= e_m * e_plus + (len_s - e_m) * e_minus
            e_left = (e_cm - e_e1) / max(abs(v(v~=0)));
            e_right = (e_cm + e_e2) / min(abs(v(v~=0)));
            e_sum = 0;
            while abs(e_sum - e_ce2) > 0.5
                e_mid = e_left + (e_right - e_left) / 2;
                e_beta = e_mid;
                e_ind1 = e_beta^2 * abs(v).^2 > e_plus;
                e_ind2 = e_beta^2 * abs(v).^2 < e_minus;
                e_sum = e_beta^2 * sum(abs(v(~e_ind1 & ~e_ind2).^2)) +...
                    sum(e_ind1) * e_plus + sum(e_ind2) * e_minus;
                if e_sum > e_ce2
                    e_right = e_mid;
                elseif e_sum < e_ce2
                    e_left = e_mid;
                else
                    break;
                end
            end
            e_ind1 = e_beta^2 * abs(v).^2 > e_plus;
            e_ind2 = e_beta^2 * abs(v).^2 < e_minus;
            e_ind3 = ~e_ind1 & ~e_ind2;
            s(e_ind3) = e_beta * abs(v(e_ind3)) .* exp(1i * angle(v(e_ind3)));
            s(e_ind1) = (e_cm + e_e2) * exp(1i * angle(v(e_ind1)));
            s(e_ind2) = (e_cm - e_e1) * exp(1i * angle(v(e_ind2)));
        end
    else
        s = s ./ abs(s);
    end
   
    
    
    phi_S = phi(s*s',K,Ak,q,theta,N,Nr);
    f = obj_func(s,A0,phi_S,eye(N*Nr));
    iterDiff = norm(f - fPre);

    
    temp = (phi_S + eye(N*Nr));
    filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);
    %func(iter) = f;
    sinr(iter) = SINR(filter,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v);
    time(iter) = cputime - t0;
if mode.visualization
    if iter == end_iter || iterDiff <= epsilon
        
        if evaluation == 1
            change_scale(:) = (change_scale-min(change_scale))/(max(change_scale)-min(change_scale))*5+34;
            plot(time(1:iter-1),sinr(1:iter-1),time(1:iter-1),change_scale(1:iter-1));
        end
        if evaluation == 0
            figure(1)
            if acceleration
                if mode.log
                    fig1 = semilogx(1:iter-1,sinr(1:iter-1),'b');
                    xlabel('log-Iterations');
                else
                    fig1 = plot(1:iter-1,sinr(1:iter-1),'b');
                    xlabel('Iterations');
                end
            else
                hold on
                if mode.log
                    fig1 = semilogx(1:iter-1,sinr(1:iter-1),'b--');
                    xlabel('log-Iterations');
                else
                    fig1 = plot(1:iter-1,sinr(1:iter-1),'b--');
                    xlabel('Iterations');
                end
            end
            
            ylabel('SINR(dB)')
            hold off
            if SimiCon
                name = 'SimiCon';
            elseif e_Uncertain
                name = 'e_Uncertain';
            elseif PAR
                name = 'PAR';
            else
                name = 'origin';
            end
            if mode.log
                print([name,'_iteration_log'],'-depsc','-painters')
                print([name,'_iteration_log_png'],'-dpng')
            else
                print([name,'_iteration'],'-depsc','-painters')
                print([name,'_iteration_png'],'-dpng')
            end
            figure(2)
            if acceleration
                if mode.log
                    fig2 = semilogx(time(1:iter-1),sinr(1:iter-1),'b');
                    xlabel('log-CPU time(log(s))');
                else
                    fig2 = plot(time(1:iter-1),sinr(1:iter-1),'b');
                    xlabel('CPU time(s)');
                end
            else
                hold on
                if mode.log
                    fig2 = semilogx(time(1:iter-1),sinr(1:iter-1),'b--');
                    xlabel('log-CPU time(log(s))');
                else
                    fig2 = plot(time(1:iter-1),sinr(1:iter-1),'b--');
                    xlabel('CPU time(s)');
                end
                
            end
            
            ylabel('SINR(dB)')

            hold off
            if mode.log
                print([name,'_runtime_log'],'-depsc','-painters')
                print([name,'_runtime_log_png'],'-dpng')
            else
                print([name,'_runtime'],'-depsc','-painters')
                print([name,'_runtime_png'],'-dpng')
            end
            
        end
        if mode.log
            save([name,'_CCM_data_log.mat'],'s','sinr','iter','time');
        else
            save([name,'_CCM_data.mat'],'s','sinr','iter','time');
        end
        %xlabel('CPU time(s)');

%         figure(2)
%         plot(time(1:iter-1),func(1:iter-1));
    end
end
    iter = iter + 1;
end

temp = (phi_S + eye(N*Nr));
filter = (temp \ A0 * s)/(s'*A0'*temp*A0*s);

if mode.clc
    clc;clear;
end
end