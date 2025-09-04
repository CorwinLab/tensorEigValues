p = 5;
numSamples = 10000;

for N=5:8
    getEigVals(sprintf('./Data/%i/%i', p, N), '0', '0', num2str(p), num2str(N), num2str(numSamples));
end