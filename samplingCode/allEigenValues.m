function [] = allEigenValues(dir, sysID, seed, N, numSamples, ensemble)

directory = sprintf("%s", dir);
cd(directory);
ensemble = sprintf("%s", ensemble);
N = str2num(N);
numSamples = str2num(numSamples);

rng(str2num(seed));

if strcmp(ensemble, 'Cyclic')
    getTensor = @getCyclicTensor;
elseif strcmp(ensemble, 'ConstantVariance')
    getTensor = @getConstantVarianceTensor;
else
    ME = MException("Ensemble is not correct");
    throw(ME);
end

for i=1:numSamples
    arr = getTensor(N);
    s = rng;
    [lambda, V, res, cnd] = zeig(double(full(arr)));
    rng(s);
    fileName = sprintf("%s/EigenValues%i.txt", dir, i);
    writematrix(lambda', fileName);
end

end
