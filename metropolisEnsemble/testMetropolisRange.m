
rng('shuffle');
ensemble = 'ConstantVariance';
N = 3;
binLambdaMin = 0.25;
binLambdaMax = 14.25;
nBins = 30;
width = 1;
tMax = 1000000;

span = binLambdaMax - binLambdaMin;
evenChunks = 4;
chunkWidth = span/evenChunks;
oddChunks = 3;
evenList = binLambdaMin + chunkWidth * ((1:evenChunks) - 1);
oddList = binLambdaMin + chunkWidth/2 + chunkWidth * ((1:oddChunks) - 1);
%evenList(end+1) = binLambdaMax
%oddList(end+1) = binLambdaMax - chunkWidth / 2

lowerBinEdges = sort([evenList, oddList]);

MCMCs = {};

for i=1:length(lowerBinEdges)
    edge = lowerBinEdges(i);
    metro = metropolisRange(ensemble, N, edge, edge+chunkWidth, 6, 1, i);
    MCMCs{end+1} = metro;
end

parfor i=1:length(MCMCs)
    for t=1:tMax
        MCMCs{i} = MCMCs{i}.iterateTimeStep();
    end
end

