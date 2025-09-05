function [] = allEigenValues(dir, seed, N, numSamples, ensemble)
% Syntax:
%  allEigenValues(dir, sysID, seed, N, numSamples, ensemble) Calculates all
%  of the z-eigenvalues for "numSamples" number of tensors drawn from the 
%  "ensemble" ensemble. All of the z-eigenvalues are saved to the "dir"
%  directory as "EigenValues{i}.txt" where "i" is the tensor number. 
% 
% Input Arguments:
%  - dir (string) -
%    Directory to store the eigenvalues in
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
% Usage:
%
%  Example 1 - Save z-eigenvalues of 10 tensors to the current directory::
%
%    allEigenValues(".", "0", "7", "10", "Cyclic");
% 
% Note: I don't think this will work in parallel. That's because z-eig
% makes a new temp file when calculating the z-eigenvalues and will throw
% an error if this file already exists. 

rng(str2num(seed));

directory = sprintf("%s", dir);
cd(directory);

ensemble = sprintf("%s", ensemble);
N = str2num(N);
numSamples = str2num(numSamples);

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
    lambda = zeig(double(full(arr)));
    rng(s);

    fileName = sprintf("%s/EigenValues%i.txt", dir, i);
    writematrix(lambda', fileName);
end

end
