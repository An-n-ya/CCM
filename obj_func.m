function res = obj_func(s,A0,phi_S,I)%scale
    res = - s' * (A0' / (phi_S + I) * A0) * s;
end