clc;clear;
N = 32;
s = exp(rand(N,1)*1i*2*pi);
f = s*s';

ds = 0.1*rand(N,1);
f_new = (s+ds)*(s+ds)';

df = zeros(N,N,N);
for k = 1:N
    df(:,k,k) = s;
    df(k,:,k) = s';
    df(k,k,k) = 2*(real(s(k))+imag(s(k)));
end
delta = zeros(N,N);
for k = 1:N
    delta = delta + df(:,:,k)*ds(k);
end
f_d = f + delta;

%evaluation
e1 = norm(f_new-f,2);
e2 = norm(f_d - f, 2);
error = (e2-e1)/e1