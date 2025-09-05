function [] = largestEigenValue(dir, sysID, seed, N, numSamples, ensemble, eigenValueType)
% Syntax:
%  largestEigenValue(dir, sysID, seed, N, numSamples, ensemble) Calculates
%  the largest eigenvalue for "numSamples" number of tensors drawn from
%  the "ensemble" ensemble. The largest eigenvalues are saved to the "dir"
%  directory as "EigenValues{sysID}.txt". 
% 
% Input Arguments:
%  - dir (string) -
%    Directory to store the eigenvalues in
%  
%  - sysID (string)
%
%  - seed (string) -
%    Random number generate seed. 
%
%  - N (string) -
%    Length of each dimension of the tensor. Must satisfy N>2. 
%
%  - numSamples (string) -
%    Number of random tensors to sample z-eigenvalues from
%  
%  - ensemble (string) - 
%    Tensor ensemble to sample from. Only options are "Cyclic" or 
%    "ConstantVariance". Throws an error otherwise. 
% 
%  - eigenValueType (string) - 
%    The type of eigenvalue to calculate. Must be either "z" or "h".
%    Default is set to "z". 
%
% Usage:
%
%  Example 1 - Save the largest z-eigenvalues of 10 tensors to 
%  the current directory::
%
%    allEigenValues(".", "0", "0", "7", "10", "Cyclic");

arguments
    dir char;
    sysID char;
    seed char;
    N char;
    numSamples char;
    ensemble char;
    eigenValueType char = 'z'
end

rng(str2num(seed));

directory = sprintf("%s", dir);
cd(directory);

ensemble = sprintf("%s", ensemble);
N = str2num(N);
numSamples = str2num(numSamples);

saveFileName = sprintf("%s/%sEigenValues%s.txt", dir, eigenValueType, sysID);
eigenValues = zeros(numSamples, 2);

if strcmp(ensemble, 'Cyclic')
    getTensor = @getCyclicTensor;
elseif strcmp(ensemble, 'ConstantVariance')
    getTensor = @getConstantVarianceTensor;
else
    ME = MException("Ensemble is not correct");
    throw(ME);
end

if strcmp(eigenValueType, 'z')
    eigenValueFunction = @zeig;
elseif strcmp(eigenValueType, 'h')
    eigenValueFunction = @heig;
else
    ME = MException("Type of eigenvalue is not valid");
    throw(ME);
end

for i=1:numSamples
    arr = getTensor(N);

    s = rng;
    [lambda, ~, res, ~] = eigenValueFunction(double(full(arr)));
    rng(s);

    eigenValues(i, 1) = lambda(end);
    eigenValues(i, 2) = res(end);
end

writematrix(eigenValues, saveFileName);
end
