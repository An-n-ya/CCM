mode.log = false;
mode.clc = false;
mode.visualization = false;

mode.SimiCon = true;
mode.PAR = false;
mode.e = false;
% initial s0
Nt = 10;
N = 8;
s_init = zeros(Nt, N);
for k = 1:Nt
    for n = 1:N
            s_init(k,n) = exp(1i * 2 * ...
                pi * (n - 1) * (k + n - 1) / N) ;
    end
end
s0 = s_init(:);

for j = 1:2
    mode.acceleration = j == 1;
    mode.acceleration = j == 1;
    s = CCM(mode);
    subplot(4,1,2*j-1)
    plot(1:80,angle(s))
    hold on
    plot(1:80,angle(s0))
    if j == 1
        legend('CCM-Armijo','LFM','Location','southeast')
    else
        legend('CCM','LFM','Location','southeast')
    end
    ylabel("Phase")
    
    s = MIA(mode);
    subplot(4,1,2*j)
    plot(1:80,angle(s))
    hold on
    plot(1:80,angle(s0))
    if j == 1
        legend('MM-SQUAREM','LFM','Location','southeast')
    else
        legend('MM','LFM','Location','southeast')
        xlabel("Sequence index")
    end
    ylabel("Phase")
end
print('phase_comparing','-depsc','-painters')
print('phase_comparing_png','-dpng')
