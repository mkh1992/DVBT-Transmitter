% Convolutional Deinterleaver
function toInnerCoder=outerInterleaver(toInterleaver)
interleaver = comm.ConvolutionalInterleaver('NumRegisters',12,'RegisterLengthStep',17);
toInnerCoder=interleaver(toInterleaver);