%Reed Solomon Decoder
function toOuterIntleaver=RSenc(toRS)
RSenc = comm.RSEncoder ('CodewordLength',255,'MessageLength',239,...
    'ShortMessageLength',188, 'GeneratorPolynomialSource','Property',...
    'GeneratorPolynomial',rsgenpoly(255,239,285,0));
L=floor(length(toRS)/188);
coded = zeros(L,204);
for i = 1:L
    coded(i,:) =RSenc(toRS((188*(i-1)+1):(188*i))) ;
end
toOuterIntleaver = reshape(coded',L*204,1);