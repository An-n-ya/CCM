function df = fun_grad( s, A0,phi_S,K,q,Ak )
    
    [len_s,w] = size(s);
    dss = zeros(len_s,len_s);
    roujia_loop_ans = zeros(len_s,len_s);
    roujia_v2 = zeros(len_s,len_s);
    I_len_s = eye(len_s);
    first_term = 2 * (A0' / (phi_S + I_len_s) * A0) * s;
    roujia_v1 = (phi_S+I_len_s) \ A0 * s;
    
    roujia_v3 = ctranspose(s) * ctranspose(A0) / (phi_S + eye(len_s));
    for i = 1:len_s
        dss(:,:) = 0;
        dss(:,i) = s;
        dss(i,:) = s';
        dss(i,i) = 2 * (real(s(i))+imag(s(i)));
        roujia_loop_ans(:,:) = 0;
        for k = 1:K  
            roujia_loop_ans = roujia_loop_ans + q(k) * Ak(:,:,k)* dss * Ak(:,:,k)';
        end
        roujia_v2(i,:) = roujia_v3 * roujia_loop_ans;
    end
    
    %roujia_vec = repmat(ctranspose(roujia_v1),[1,len_s]);
    
    last_term = roujia_v2 * roujia_v1;
    df = (first_term + last_term);

return;