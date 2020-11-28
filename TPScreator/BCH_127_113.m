function Encoded=BCH_127_113(input)
[m,n]=size(input);
if m == 1 && n == 113
registers = (zeros(1,14));
polinomyal = [1 0 0 0 0 1 1 0 1 1 1 0 1 1 1];
polinomyal = polinomyal(end:-1:2);
for i = 1:113
    addres = mod(input(i)+registers(end),2);
    registers=mod(and(polinomyal,addres)+[0,registers(1:end-1)],2);
end
Encoded=[input,registers(end:-1:1)];
else
    fprintf('ERROR in BCHencoder: incorrect Inputsize \n')
end