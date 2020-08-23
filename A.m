function res = A(theta,rk,N,Nr,Nt)%N*Nr ¡Á N*Nt
    I = eye(N);
    temp = at(theta,Nr) * at(theta,Nt)';
    len_s = N*Nt;
    J = zeros(len_s,len_s);
    for i = 1:len_s
        for j = 1:len_s
            if i - j == Nt * rk
                J(i,j) = 1;
            end
        end
    end
    %J = vertcat(horzcat(zeros(Nt*(N - rk),Nt*rk),eye(Nt*(N - rk))),zeros(Nt*rk,Nt*N));
    res = kron(I,temp)*J;
end