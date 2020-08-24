mode.log = true;
for i = 1:4
    mode.SimiCon = i == 2;
    mode.PAR = i == 3;
    mode.e = i == 4;
    for j = 1:2
        mode.acceleration = j == 1;
        mode.acceleration = j == 1;
        CCM(mode);
        MIA(mode);

    end
end