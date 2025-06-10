rng('shuffle');
ensemble = 'ConstantVariance';
N = 10;
binLambdaMin = 6;
binLambdaMax = 20;
width = 0.2;
tMax = 10000000;

span = binLambdaMax - binLambdaMin;
evenChunks = 32;
chunkWidth = span/evenChunks;
oddChunks = 31;
evenList = binLambdaMin + chunkWidth * ((1:evenChunks) - 1);
oddList = binLambdaMin + chunkWidth/2 + chunkWidth * ((1:oddChunks) - 1);

lowerBinEdges = sort([evenList, oddList]);

MCMCs = cell(length(lowerBinEdges), 1);

parpool(64)

disp("Initializing starting tensors");
parfor i=1:length(lowerBinEdges)
    edge = lowerBinEdges(i);
    metro = metropolisRange(ensemble, N, edge, edge+chunkWidth, 9, width, i);
    MCMCs{i} = metro;
end
disp("Done initializing tensors");

parfor i=1:length(MCMCs)
    singleMCMC = MCMCs{i};
    for t=1:tMax
        singleMCMC = singleMCMC.iterateTimeStep();
    end
    MCMCs{i} = singleMCMC;
end

