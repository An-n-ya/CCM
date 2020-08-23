function s = proj_to(proj,s)
    v = s;
    [len_s,~] = size(v);
    if proj.SimiCon.value
        proj.SimiCon.phi_opt = zeros(len_s,1);
        proj.SimiCon.phi = angle(-v);
        for i = 1 : len_s
            if proj.SimiCon.gamma(i) < (proj.SimiCon.phi(i)) &&...
                    proj.SimiCon.gamma(i)+proj.SimiCon.delta >...
                    (proj.SimiCon.phi(i))
                proj.SimiCon.phi_opt(i) = (proj.SimiCon.phi(i));
            elseif real(conj(v(i)) * ...
                    exp(1i * (proj.SimiCon.gamma(i)+proj.SimiCon.delta))) >...
                    real(conj(v(i)) * exp(1i * proj.SimiCon.gamma(i)))
                proj.SimiCon.phi_opt(i) = proj.SimiCon.gamma(i);
            else
                proj.SimiCon.phi_opt(i) = proj.SimiCon.gamma(i)+proj.SimiCon.delta;
            end
        end
        s =  exp(1i*proj.SimiCon.phi_opt) ;
    elseif proj.PAR.value
        proj.PAR.m = sum(v~=0);
        if proj.PAR.m * proj.PAR.gamma <= len_s
            s(v~=0) = - sqrt(proj.PAR.gamma) * exp(1i*angle(v(v~=0)));
            s(v==0) = - sqrt((len_s - proj.PAR.m * proj.PAR.gamma)/...
                (len_s - proj.PAR.m)) * exp(1i*angle(v(v==0)));
        else
            proj.PAR.left = 0;
            proj.PAR.right = sqrt(proj.PAR.gamma)/min(abs(v(v~=0)));
            proj.PAR.sum = 0;
            while abs(proj.PAR.sum - proj.PAR.N) > 0.3
                proj.PAR.mid = proj.PAR.left + (proj.PAR.right...
                    - proj.PAR.left) / 2;
                proj.PAR.beta = proj.PAR.mid;
                proj.PAR.ind1 = proj.PAR.beta^2 * abs(v).^2 >...
                    proj.PAR.gamma;
                proj.PAR.sum = proj.PAR.beta^2 * ...
                    sum(abs(v(~proj.PAR.ind1)).^2) + ...
                    sum(proj.PAR.ind1) * proj.PAR.gamma;
                if proj.PAR.sum > proj.PAR.N
                    proj.PAR.right = proj.PAR.mid;
                elseif proj.PAR.sum < proj.PAR.N
                    proj.PAR.left = proj.PAR.mid;
                else
                    break;
                end
            end
            proj.PAR.ind2 = proj.PAR.beta * abs(v) >...
                proj.PAR.gamma;
            s(proj.PAR.ind2) = - sqrt(proj.PAR.gamma)...
                * exp(1i*angle(v(proj.PAR.ind2)));
            s(~proj.PAR.ind2) = - proj.PAR.beta * ...
                abs(v(~proj.PAR.ind2)) .* ...
                exp(1i*angle(v(~proj.PAR.ind2)));
        end
    elseif proj.e.value
        proj.e.ind = v~=0;
        proj.e.m = sum(proj.e.ind);
        proj.e.plus = (proj.e.cm+proj.e.e2)^2;
        proj.e.minus = (proj.e.cm-proj.e.e1)^2;
        if proj.e.m * proj.e.plus + (len_s - ...
                proj.e.m) * proj.e.minus <= proj.e.ce2 &&...
                proj.e.ce2 <= len_s * proj.e.plus
            s(proj.e.ind) = - (proj.e.cm + proj.e.e2) *...
                exp(1i*angle(v(proj.e.ind2)));
            s(~proj.e.ind) = - sqrt((proj.e.ce2-proj.e.m...
                * proj.e.plus) / (proj.e.len_s - proj.e.m)) *...
                exp(1i*angle(v(~proj.e.ind2)));
        elseif len_s * proj.e.minus <= proj.e.ce2 &&...
                proj.e.ce2 <= proj.e.m * proj.e.plus + ...
                (len_s - proj.e.m) * proj.e.minus
            proj.e.left = (proj.e.cm - proj.e.e1) / max(abs(v(v~=0)));
            proj.e.right = (proj.e.cm + proj.e.e2) / min(abs(v(v~=0)));
            proj.e.sum = 0;
            while abs(proj.e.sum - proj.e.ce2) > 0.5
                proj.e.mid = proj.e.left + (proj.e.right - proj.e.left) / 2;
                proj.e.beta = proj.e.mid;
                proj.e.ind1 = proj.e.beta^2 * abs(v).^2 > proj.e.plus;
                proj.e.ind2 = proj.e.beta^2 * abs(v).^2 < proj.e.minus;
                proj.e.sum = proj.e.beta^2 * sum(abs(v(~proj.e.ind1 & ~proj.e.ind2).^2)) +...
                    sum(proj.e.ind1) * proj.e.plus + sum(proj.e.ind2) * proj.e.minus;
                if proj.e.sum > proj.e.ce2
                    proj.e.right = proj.e.mid;
                elseif proj.e.sum < proj.e.ce2
                    proj.e.left = proj.e.mid;
                else
                    break;
                end
            end
            proj.e.ind1 = proj.e.beta^2 * abs(v).^2 > proj.e.plus;
            proj.e.ind2 = proj.e.beta^2 * abs(v).^2 < proj.e.minus;
            proj.e.ind3 = ~proj.e.ind1 & ~proj.e.ind2;
            s(proj.e.ind3) = - proj.e.beta * abs(v(proj.e.ind3)) .* exp(1i * angle(v(proj.e.ind3)));
            s(proj.e.ind1) = - (proj.e.cm + proj.e.e2) * exp(1i * angle(v(proj.e.ind1)));
            s(proj.e.ind2) = - (proj.e.cm - proj.e.e1) * exp(1i * angle(v(proj.e.ind2)));
        end
        
    else
        s = - exp(1i*angle(v)) ;
    end
end