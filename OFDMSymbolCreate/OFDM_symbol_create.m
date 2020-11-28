function OFDMSymbol=OFDM_symbol_create(data,TPS,symNum,mode,guard)
%data = OFDM_data,TPS=TPS68DBPSK(symNum+1),symNum=0,mode='2k',guard='1/8'
persistent Guard OFDM_cells CPL TCL SPC Mode  PRBSequence PRBSequenceBoosted
if isempty(Guard)
    Guard = str2num(guard);
    switch mode
        case '2k'
            OFDM_cells = 1705;
            Mode = 2048;
        case '8k'
            OFDM_cells = 6817;
            Mode = 8192;
    end
    %% Continual pilot Location
    CPL = zeros(OFDM_cells,1);
    pilots =[0,48,54,87,141,156,192,201,255,279,...
        282,333,432,450,483,525,531,618,636,...
        714,759,765,780,804,873,888,918,939,...
        942,969,984,1050,1101,1107,1110,1137,...
        1140,1146,1206,1269,1323,1377,1491,1683,...
        1704,1752,1758,1791,1845,1860,1896,1905,...
        1959,1983,1986,2037,2136,2154,2187,2229,...
        2235,2322,2340,2418,2463,2469,2484,2508,...
        2577,2592,2622,2643,2646,2673,2688,2754,...
        2805,2811,2814,2841,2844,2850,2910,2973,...
        3027,3081,3195,3387,3408,3456,3462,3495,...
        3549,3564,3600,3609,3663,3687,3690,3741,...
        3840,3858,3891,3933,3939,4026,4044,4122,...
        4167,4173,4188,4212,4281,4296,4326,4347,...
        4350,4377,4392,4458,4509,4515,4518,4545,...
        4548,4554,4614,4677,4731,4785,4899,5091,...
        5112,5160,5166,5199,5253,5268,5304,5313,...
        5367,5391,5394,5445,5544,5562,5595,5637,...
        5643,5730,5748,5826,5871,5877,5892,5916,...
        5985,6000,6030,6051,6054,6081,6096,6162,...
        6213,6219,6222,6249,6252,6258,6318,6381,...
        6435,6489,6603,6795,6816]+1;
    if OFDM_cells == 1705
        pilots = pilots(pilots<=1705);
    end
    CPL(pilots)=1;
    %% TRANSPORT PARAMETER SIGNALING LOCATION
    TCL = zeros(OFDM_cells,1);
    TPScells = [34,50,209,346,413,569,595,688,...
            790,901,1073,1219,1262,1286,1469,1594,...
            1687,1738,1754,1913,2050,2117,2273,2299,...
            2392,2494,2605,2777,2923,2966,2990,3173,...
            3298,3391,3442,3458,3617,3754,3821,3977,...
            4003,4096,4198,4309,4481,4627,4670,4694,...
            4877,5002,5095,5146,5162,5321,5458,5525,...
            5681,5707,5800,5902,6013,6185,6331,6374,...
            6398,6581,6706,6799]+1;
    if OFDM_cells == 1705
        TPScells = TPScells(TPScells<=1705);
    end
    TCL(TPScells)=1;
    %% Scattered Poilot location in Frame
    SPC = zeros(OFDM_cells,4);
    SPC(13:12:end,1)=1;
    SPC(4:12:end,2)=1;
    SPC(7:12:end,3)=1;
    SPC(10:12:end,4)=1;
    %% PRBS GENERATOR
    numOut = OFDM_cells;
    ini = ones(1,11);
    PRBSequence = zeros(1,numOut);
    for i = 1 : numOut
        PRBSequence(i) = ini(11);
        temp = xor(ini(11),ini(9));
        ini  = circshift(ini,1);
        ini(1) = temp;
    end
    PRBSequenceBoosted = 4/3*2*(0.5-PRBSequence);
end
%% OFDM FRAME
FFT_domain = zeros(OFDM_cells,1);
FFT_domain(CPL==1)=PRBSequenceBoosted(CPL==1);
FFT_domain(SPC(:,mod(symNum,4)+1)==1)=PRBSequenceBoosted(SPC(:,mod(symNum,4)+1)==1);
FFT_domain(TCL==1) = TPS*2*(1/2-PRBSequence(TCL==1));
FFT_domain(FFT_domain==0) = data;
FFT_domain=[FFT_domain(((end-1)/2+1):end);zeros(Mode-OFDM_cells,1);FFT_domain(1:(end-1)/2)];
IFFT_domain = ifft(FFT_domain);
OFDMSymbol=[IFFT_domain((Mode-Guard*Mode+1):Mode);IFFT_domain];

