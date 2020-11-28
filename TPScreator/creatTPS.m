function [TPS68DBPSK,TPS68] = creatTPS(superFrameNum,cellID,constellation,CR,GuardInterval,mode)
TPS53bits = zeros(53,1);
switch mod(superFrameNum,2)
    case 0
        TPS53bits(1:16) = [1 1 0 0 1 0 1 0 0 0 0 1 0 0 0 1];
    case 1
        TPS53bits(1:16) = [0 0 1 1 0 1 0 1 1 1 1 0 1 1 1 0];
end
if ~isnumeric(cellID)
    TPS53bits(17:22) = [0 1 0 1 1 1];
elseif ~isnumeric(cellID)
       TPS53bits(17:22) = [0 1 1 1 1 1];
       if mod(superFrameNum,2) == 0
           TPS53bits(40:47) = cellID(8:-1:1);
       elseif mod(superFrameNum,2) == 1
           TPS53bits(40:47) = cellID(16:-1:9);
       end
end
switch superFrameNum
    case 1
        TPS53bits(23:24)=[0,0];
    case 2
        TPS53bits(23:24)=[0,1];
    case 3
        TPS53bits(23:24)=[1,0];
    case 4
        TPS53bits(23:24)=[1,1];
end
switch constellation
    case 'QPSK'
        TPS53bits(25:26)=[0,0];
    case '16QAM'
        TPS53bits(25:26)=[0,1];
    case '64QAM'
        TPS53bits(25:26)=[1,0];
end
TPS53bits(27:29) = [0,0,0]; % Hierarchy Information... this Code doesn't support Hierarchical Transmittion
switch CR
    case '1/2'
       TPS53bits(30:35) =  [0,0,0,0,0,0];
    case '2/3'
        TPS53bits(30:35) =  [0,0,1,0,0,1];
    case '3/4'
        TPS53bits(30:35) =  [0,1,0,0,0,0];
    case '5/6'
        TPS53bits(30:35) =  [0,1,1,0,0,0];
    case '7/8'
        TPS53bits(30:35) =  [1,0,0,0,0,0];
end
switch GuardInterval
    case '1/32'
        TPS53bits(36:37) =[0,0];
    case '1/16'
        TPS53bits(36:37) =[0,1];
    case '1/8'
        TPS53bits(36:37) =[1,0];
    case '1/4'
        TPS53bits(36:37) =[1,1];
end
switch mode
    case '2k'
        TPS53bits(38:39) =[0,0];
    case '8k'
        TPS53bits(38:39) =[0,1];
end
%% test
Code = BCH_127_113([zeros(1,60),TPS53bits']);
Code = Code(61:end);
%%
TPS68 = [0,Code];
TPS68DBPSK = DBPSKmod(TPS68');
