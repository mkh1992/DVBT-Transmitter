function ofdmData = modulator(modIn,modulation)

if strcmp(modulation,'64QAM')
    dvbtSymorder = [32,33,37,36,52,53,49,48,34,35,39,...
        38,54,55,51,50,42,43,47,46,62,63,59,58,40,41,...
        45,44,60,61,57,56,8,9,13,12,28,29,25,24,10,11,...
        15,14,30,31,27,26,2,3,7,6,22,23,19,18,0,1,5,4,...
        20,21,17,16];
    ofdmData = qammod(modIn,64,dvbtSymorder,'UnitAveragePower', true);
end
if strcmp(modulation,'16QAM')
    dvbtSymorder = [8,9,13,12,10,11,15,14,2,3,7,6,0,1,5,4];
    ofdmData = qammod(modIn,16,dvbtSymorder,'UnitAveragePower', true);
end
if strcmp(modulation,'QPSK')
    dvbtSymorder = [2,3,0,1];
    ofdmData = qammod(modIn,4,dvbtSymorder,'UnitAveragePower', true);
end