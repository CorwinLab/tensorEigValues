rng('shuffle');
ensemble = 'ConstantVariance';
N = 10;
binLambdaMin = 3;
binLambdaMax = 9;
nBins = 30;
width = 1;
tMax = 1000000;

span = binLambdaMax - binLambdaMin;
evenChunks = 16;
chunkWidth = span/evenChunks;
oddChunks = 15;
evenList = binLambdaMin + chunkWidth * ((1:evenChunks) - 1);
oddList = binLambdaMin + chunkWidth/2 + chunkWidth * ((1:oddChunks) - 1);
%evenList(end+1) = binLambdaMax
%oddList(end+1) = binLambdaMax - chunkWidth / 2

lowerBinEdges = sort([evenList, oddList]);

MCMCs = {};

for i=1:length(lowerBinEdges)
    edge = lowerBinEdges(i);
    metro = metropolisRange(ensemble, N, edge, edge+chunkWidth, 8, 1, i+32);
    MCMCs{end+1} = metro;
end

parpool(32);
parfor i=1:length(MCMCs)
    A = symtensor(@randn, 3, 3);
    singleMCMC = MCMCs{i};
    for t=1:tMax
        singleMCMC = singleMCMC.iterateTimeStep();
    end
    MCMCs{i} = singleMCMC;
end

