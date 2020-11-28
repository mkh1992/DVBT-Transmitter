% DBPSK modulator
function output = DBPSKmod(input)
output = zeros(length(input),1);
output(1) = 1;
for i = 2:length(input)
    if input(i) ==0
        output(i) = output(i-1);
    elseif input(i) ==1
        output(i) = -output(i-1);
    end
end