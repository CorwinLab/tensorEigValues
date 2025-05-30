function [] = largestEigenValue(dir, sysID, seed, N, numSamples, ensemble)

directory = sprintf("%s", dir);
cd(directory);
ensemble = sprintf("%s", ensemble);
N = str2num(N);
numSamples = str2num(numSamples);
fileName = sprintf("%s/EigenValues%s.txt", dir, sysID);
eigenValues = zeros(numSamples, 2);

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
    [lambda, V, res, cnd] = zeig(arr);
    display(lambda);
    rng(s);
    eigenValues(i, 1) = lambda(end);
    eigenValues(i, 2) = res(end);
end

writematrix(eigenValues, fileName);
end
