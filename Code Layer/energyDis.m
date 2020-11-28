function toRSenc=energyDis(MPEGdata)
numMPEG2 = length(MPEGdata)/1504;
MPEGdata(1:188*8:end) = 184;
ini = [1 0 0 1 0 1 0 1 0 0 0 0 0 0 0];
rndPRBS = zeros(1,1503*8);
for i = 1 : 1503*8
    rndPRBS(i) = xor(ini(15),ini(14));
    ini  = circshift(ini,1);
    ini(1) = rndPRBS(i);
end
rndPRBS=[zeros(1,8),rndPRBS];
En=[zeros(1,8),ones(1,187*8)];
Enable = repmat(En,1,8);
andres = and(Enable,rndPRBS);
andres = repmat(andres,1,numMPEG2);
bits2derand=de2bi(MPEGdata,'left-msb');
bits2derand=reshape(bits2derand',1,188*8*8*numMPEG2);
temptoRSenc=xor(bits2derand,andres);
temptoRSenc = reshape(temptoRSenc,8,numMPEG2*1504);
toRSenc=bi2de(temptoRSenc','left-msb');

    
     
    