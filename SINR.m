function res = SINR(w,A0,Ak,theta,N,Nr,K,s,sigma_0,sigma_k,sigma_v)%scale
    numerator = sigma_0^2 * norm(w'*A0*s)^2;
    S = s * s';
    temp = phi(S,K,Ak,sigma_k.^2,theta,N,Nr);
    denominator = w' * temp * w + sigma_v * w' * w;
    res = 10 * log10(abs(numerator / denominator));
end