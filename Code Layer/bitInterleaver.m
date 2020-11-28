function toSymbolInterleaver = bitInterleaver(toBitinterleaver,mode)
[v,~] = size(toBitinterleaver);
toBitinterleaver=toBitinterleaver';
switch mode
    case '2k'
        numIterations = 12;
    case '8k'
        numIterations = 48;
end
w=(0:125);
H0 = w;
H1(w+1) = mod((w + 63),126);
H2(w+1) = mod((w + 105),126);
H3(w+1) = mod((w + 42),126);
H4(w+1) = mod((w + 21), 126);
H5(w+1) = mod((w + 84),126);
switch v
    case 2
        bitPermu = [H0;126+H1]';
    case 4
        bitPermu = [H0;126+H1;2*126+H2;3*126+H3]';
    case 6
        bitPermu = [H0;126+H1;2*126+H2;3*126+H3;4*126+H4;5*126+H5]';
end
toSymbolInterleaver=zeros(numIterations*126,v);
for i = 1:numIterations
    temp = toBitinterleaver((126*(i-1)+1):126*i,:);
    toSymbolInterleaver((126*(i-1)+1):126*i,:) = temp(bitPermu+1);
end
