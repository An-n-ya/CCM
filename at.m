function res = at(theta,Nt)
    res = zeros(Nt,1);
    a = sin(theta * pi / 180);
    for k = 1:Nt
        power = -1i * pi * (k-1) * a;
        res(k) = exp(power);
    end
    res = res ./ sqrt(Nt);
end