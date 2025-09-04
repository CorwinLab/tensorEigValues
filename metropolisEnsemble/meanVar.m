
numSamples = 100;
samples = zeros(numSamples, 1);

for i=1:numSamples
    A = getConstantVarianceTensor(10);
    s = rng;
    lambda = zeig(double(full(A)));
    rng(s);
    maxLambda = max(lambda);
    samples(i) = maxLambda;
    disp(maxLambda);
end