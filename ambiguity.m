function ambiguity(x,Nt,N,theta_c)
    s = reshape(x,[Nt,N]);
    Ae = zeros(2*N+1,181);
    c = zeros(Nt,Nt,2*N+1);
    for tau = -N:N
        for t = 1:N
            c(:,:,tau+N+1) = c(:,:,tau+N+1) + s(:,t)*s(:,1+mod((t+tau),N))';
        end
    end
    steer = at(theta_c,Nt);
    for tau = -N:N
        ind = 1;
        for theta = -90:90
            Ae(tau+N+1,ind)=conj(steer')*c(:,:,tau+N+1)*at(theta,Nt);
            ind = ind + 1;
        end
    end
    subplot(4,4,[2 3 4 6 7 8 10 11 12])
    imagesc(abs(Ae));
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    shading ('interp')
    colorbar
    subplot(4,4,[1 5 9])
    plot(abs(Ae(:,107)),1:17)
    ylabel("Range");
    subplot(4,4,[14 15 16])
    plot(1:181,abs(Ae(11,:)))
    xlabel("Angle");
    
    %set(gca,'XTick',-90:15:90)
end