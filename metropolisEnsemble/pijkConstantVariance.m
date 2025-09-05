function prob = pijkConstantVariance(xijk, ~)
% Syntax:
%  pijkConstantVariance(arr) Returns the probability that xijk = x for the
%  ConstantVariance tensor ensemble at index (i, j, k). For ever index,
%  this is simply the standar normal distribution at xijk.
% 
% Input Arguments:
%  - xijk (float)
%    Value of the entry of the tensor at index (i, j, k)
%
% Note: The second entry to this function is the index. However, the index
% isn't needed to calculate the probability so that we ignore it. 
% 
% Output Arguments:
%  - prob (float)
%    Probability that xijk = x for the ConstantVariance tensor ensemble. 
% 
% Note: We really only care about the ratio of probabilities for xijk
% changing to another value. Thus, we leave out the normalization
% prefactor. 
%
% Usage:
%
%  Example 1 - Get the permutations of input array.
%
%    pijkConstantVariance(0.75, [1, 2, 3])

    prob = exp(-xijk^2 / 2);
end