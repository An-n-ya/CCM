function res = phi(S,K,Ak,q,theta,N,Nr)%N*Nr ¡Á N*Nr
    res = zeros(N*Nr,N*Nr);

    for k = 1:K  
        temp = Ak(:,:,k);
        res = res + q(k) * temp * S * temp';
    end
end