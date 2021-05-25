clear all
clear OFDM_symbol_create
clc
addpath('Code Layer','TPScreator','Constelation Demodulator','OFDMSymbolCreate')
%% Transmission Parameter Signalling
cellID = 'NOT Transmitted'; % options : 'NOT Transmitted' , a vector with 16 bits left-msb
constellation = 'QPSK';
CR = '2/3';
GuardInterval = '1/8';
mode = '8k';
%% code lyer
numMPEG2 = 1000;  % number of MPEG2 TS 8*188 Packets to Energy Dispersal
fid = fopen('test.ts','r');
MPEGdata = fread(fid,188*8*numMPEG2,'uint8');
% MPEGdata = fread(fid,'uint8');
fclose(fid);
fprintf('PRBS seq. Genedator Started \n')
toRSenc = energyDis(MPEGdata);
fprintf('RS Enc. proccess \n')
toOuterIntleaver = RSenc(toRSenc);
fprintf('Interleaving Input \n')
toInnerCoder=outerInterleaver(toOuterIntleaver);
fprintf('Conv.Enc has started \n')
toDemux=innerCoder(toInnerCoder,CR);
fprintf('Demultiplexing Data ... \n')
toBitinterleaver_total = Demuxer(toDemux,constellation);
%% OFDM frame
switch mode
    case '2k'
        BitInterleaverLength = 12*126;
    case '8k'
        BitInterleaverLength = 48*126;
end
fprintf('Creating I/Q signal \n')
fileId = fopen('8k_1_8','w');
superFrameNum = 0;
dataIndex =0;

while length(toBitinterleaver_total) - BitInterleaverLength*68 > dataIndex(end)
    TPS68DBPSK = creatTPS(mod(superFrameNum,4)+1,cellID,constellation,CR,GuardInterval,mode);
    for symNum = 0:67
        dataIndex =  (BitInterleaverLength*((superFrameNum)*68+symNum)+1):...
            BitInterleaverLength*((superFrameNum)*68+symNum+1);
        toSymbolInterleaver = bitInterleaver(toBitinterleaver_total(:,dataIndex),mode);
        y=symbolInterleaver(toSymbolInterleaver,mode,symNum);
        OFDM_data = modulator(y,constellation);
        OFDMSymbol=OFDM_symbol_create(OFDM_data,TPS68DBPSK(symNum+1),symNum,mode,GuardInterval);
        tofile=writeTofile(OFDMSymbol);
        fwrite(fileId,tofile,'float');
    end
    superFrameNum = superFrameNum+1;
    fprintf('Frame number %d Created Successfully \n',superFrameNum)
end
fclose('all');