function tofile=writeTofile(OFDMSymbol)
IQinterleave = [real(OFDMSymbol),imag(OFDMSymbol)]';
tofile=reshape(IQinterleave,length(IQinterleave)*2,1);
