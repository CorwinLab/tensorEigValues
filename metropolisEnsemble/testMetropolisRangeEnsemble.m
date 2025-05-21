parpool(32);

rng('shuffle');
ensemble = 'ConstantVariance';
N = 3;
binLambdaMin = 0.25;
binLambdaMax = 14;
nBins = 30;
width = 1;
numWalkers = 32;
tMax = 10000000;

tensorEnsemble = metropolisRangeEnsemble(ensemble, N, binLambdaMin, binLambdaMax, nBins, width, numWalkers);

for t=1:tMax
    tensorEnsemble = tensorEnsemble.iterateTensors();
end
