function df = fun_grad( s, A0,phi_S,K,q,Ak )
    
    [len_s,~] = size(s);
    dss = zeros(len_s,len_s)*1i;
    roujia_loop_ans = zeros(len_s,len_s);
    roujia_v2 = zeros(len_s,len_s)*1i;
    I_len_s = eye(len_s);
    first_term = 2 *((A0' / (phi_S + I_len_s) * A0) * s);
    roujia_v1 = ctranspose(s) * ctranspose(A0) / (phi_S + I_len_s);
    %roujia_v3 = ctranspose(s) * ctranspose(A0) / (phi_S + eye(len_s));
%     for i = 1:len_s
%         roujia_loop_ans(:,:) = 0;
%         roujia = bsxfun(@times,Ak(:,i,:), s');
%         for k = 1:K  
%             %roujia_acc = Ak(:,i,k) * s' * Ak(:,:,k)'; 
%             roujia_acc = roujia(:,:,k)* Ak(:,:,k)'; 
%             roujia_loop_ans = roujia_loop_ans + q(k) * (roujia_acc + roujia_acc');
%         end
%        
%         roujia_v2(i,:) = roujia_v1 * roujia_loop_ans;
%     end
%     for k = 1:K  
%         %roujia_loop_ans(:,:) = 0;
%         parfor i = 1:len_s
%             dss(:,:) = 0;
%             dss(:,i) = s;%+  conjugate
%             dss(i,:) = s';
%             dss(i,i) = 2 * (real(s(i)));
%             %dss = sparse(dss);
%             roujia_loop_ans = q(k) * Ak(:,:,k)* dss * Ak(:,:,k)';
%             roujia_v2(i,:) = roujia_v2(i,:) + roujia_v1 * roujia_loop_ans;
%         end
%     end

    for i = 1:len_s
        dss(:,:) = 0;
        dss(:,i) = s;%+  conjugate
        dss(i,:) = s';
        dss(i,i) = 2 * (real(s(i)));
        %dss = sparse(dss);
        roujia_loop_ans = (q(1) * Ak(:,:,1)+q(2) * Ak(:,:,2)+q(3) * Ak(:,:,3))* dss * (Ak(:,:,1)'+Ak(:,:,2)'+Ak(:,:,3)');
        roujia_v2(i,:) = roujia_v2(i,:) + roujia_v1 * roujia_loop_ans;
    end
    
    %roujia_vec = repmat(ctranspose(roujia_v1),[1,len_s]);
    
    last_term = roujia_v2 * roujia_v1';
    
    %df = (first_term + last_term)-4*1000*100*s;
    %df = (first_term + last_term) - 4 * s;
    df = (first_term + last_term);
return;