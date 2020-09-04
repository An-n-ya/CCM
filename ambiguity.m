    Nt = 10;
    N = 8;
    theta_c = 15;
    mode.SimiCon = true;
    mode.PAR = false;
    mode.e = false;
    mode.log = false;
    mode.clc = false;
    mode.acceleration = true;
    mode.visualization = true;
    x = MIA(mode);
    
    s = reshape(x,[Nt,N]);
    Ae = zeros(2*N+1,181);
    c = zeros(Nt,Nt,2*N+1);
    %J = zeros(Nt*N,Nt*N);
    for tau = -N:N
        for t = 1:N
            if t + tau > N || t + tau <= 0
                if mod((t+tau),N) == 0
                    c(:,:,tau+N+1) = c(:,:,tau+N+1) + s(:,t)*s(:,N)';
                else
                    c(:,:,tau+N+1) = c(:,:,tau+N+1) + s(:,t)*s(:,mod((t+tau),N))';
                end
            else
                c(:,:,tau+N+1) = c(:,:,tau+N+1) + s(:,t)*s(:,t+tau)';
            end
        end
    end
    steer = at(theta_c,Nt);
    len_x = N*Nt;
    for tau = -N:N
        ind = 1;
        for theta = -90:90
            Ae(tau+N+1,ind)=steer.'*c(:,:,tau+N+1)*conj(at(theta,Nt));
%             for i = 1:len_x
%                 for j = 1:len_x
%                     if i - j == tau
%                         J(i,j) = 1;
%                     end
%                 end
%             end
            %Ae(tau+N+1,ind)=abs(x' * J * (x .* at(theta,len_x)))^2/(norm(s,2)^2);
            ind = ind + 1;
        end
    end
    Ae_max = max(max(Ae));
    [m,n] = find(Ae == Ae_max);
    Ae = log(abs(Ae)/abs(Ae_max))*24;
    
    
    subplot(4,4,[2 3 4 6 7 8 10 11 12])
    imagesc(Ae);
    hold on
    del_x = 5;
    del_y = 0.5;
    rec_x = n(2);
    rec_y = m(2);
    rectangle('Position',[rec_x - del_x/2,rec_y - del_y/2,del_x,del_y],'curvature',[1,1]);
    rec_x = 140;
    rec_y = 9;
    rectangle('Position',[rec_x - del_x/2,rec_y - del_y/2,del_x,del_y]);
    rec_x = 100;
    rec_y = 8;
    rectangle('Position',[rec_x - del_x/2,rec_y - del_y/2,del_x,del_y]);
    rec_x = 51;
    rec_y = 7;
    rectangle('Position',[rec_x - del_x/2,rec_y - del_y/2,del_x,del_y]);
    
    %set(gca,'colormap','Jet');
    set(gca,'XDir','reverse');
    set(gca,'xtick',[]);
    set(gca,'ytick',[]);
    shading ('interp')
    colorbar
    subplot(4,4,[1 5 9])
    plot(Ae(:,n(1)),1:2*N+1)
    set(gca,'YLim',[1,2*N+1]);
    set(gca,'YDir','reverse');
    set(gca,'ytick',1:round(2*N/7):2*N+1);
    set(gca,'yticklabel',-N:round(2*N/7):N);
    ylabel("Range");
    subplot(4,4,[14 15 16])
    plot(1:181,Ae(m(1),:))
    set(gca,'XDir','reverse');
    set(gca,'XLim',[0,180]);
    set(gca,'position',[0.3361,0.11,0.4643,0.1577]);
    set(gca,'xtick',0:15:180);
    set(gca,'xticklabel',90:-15:-90);
    xlabel("Angle");
    
    print('ambiguity function','-depsc','-painters')
    print('ambiguity function_png','-dpng')
    
    %set(gca,'XTick',-90:15:90)