function res = A(theta,rk,N,Nr,Nt)%N*Nr ¡Á N*Nt
    I = eye(N);
    temp = at(theta,Nr) * at(theta,Nt)';
    J = vertcat(horzcat(zeros(Nt*(N - rk),Nt*rk),eye(Nt*(N - rk))),zeros(Nt*rk,Nt*N));
    res = kron(I,temp)*J;
end