function res = SINR(w,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v)%scale
    numerator = sigma_0 * norm(w'*A0*s)^2;
    S = s * s';
    temp = phi(S,K,Ak,sigma_k,theta,N,Nr);
    denominator = real(w' * temp * w + sigma_v * (w' * w));
    %denominator = w' * temp * w;
    res = 10 * log10(numerator / denominator);
end