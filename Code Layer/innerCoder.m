%innerDecoder
function toMuxer=innerCoder(x,cr)
convInput = de2bi(x,'left-msb');
convInput = reshape(convInput',numel(convInput),1);
%%%%%%%%% matching length of binary data with code rate %%%%%%%%
[numerator,~]=rat(str2num(cr));
L = length(convInput);
newL = numerator*floor(L/numerator);
convInput = convInput(1:newL);
%%%%%%%%%%%%%%%%%%%%%%%%%% End %%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch cr
    case '1/2'
        PT = [1,1]';
    case '2/3'
        PT = [1,1,0,1]';
    case '3/4'
        PT = [1,1,0,1,1,0]';
    case '5/6'
        PT = [1,1,0,1,1,0,0,1,1,0]';
    case '7/8'
        PT = [1,1,0,1,0,1,0,1,1,0,0,1,1,0]';
end
 vitEnc = comm.ConvolutionalEncoder(poly2trellis(7, [171 133]), ...
   'PuncturePatternSource','Property','PuncturePattern',PT);
toMuxer = vitEnc(convInput);
