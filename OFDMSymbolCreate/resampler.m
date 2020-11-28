function  [y, h] = resampler(x)
p = 35;
q = 32;
bta = 5;
N = 10;
pqmax = max(p,q);
fc = 1/2/pqmax;
L = 2*N*pqmax + 1;
h = firls( L-1, [0 2*fc 2*fc 1], [1 1 0 0]).*kaiser(L,bta)' ;
h = p*h/sum(h);
Lhalf = (L-1)/2;
Lx = length(x);

% Need to delay output so that downsampling by q hits center tap of filter.
nz = floor(q-mod(Lhalf,q));
z = zeros(1,nz);
h = [z h];  % ensure that h is a row vector.
Lhalf = Lhalf + nz;

% Number of samples removed from beginning of output sequence 
% to compensate for delay of linear phase filter:
delay = floor(ceil(Lhalf)/q);

% ----  HERE'S THE CALL TO UPFIRDN  ----------------------------
x_upsample  = upsample(x,p);
x_filter = conv(x_upsample,h);
y = x_filter(1:q:end);
y = y(1:end-1);

% Get rid of trailing and leading data so input and output signals line up
% temporally:
Ly = ceil(Lx*p/q);  % output length
% Ly = floor((Lx-1)*p/q+1);  <-- alternately, to prevent "running-off" the
%                                data (extrapolation)
y(1:delay) = [];
y(Ly+1:end) = [];
