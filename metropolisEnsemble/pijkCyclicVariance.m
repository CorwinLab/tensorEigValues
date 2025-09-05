function prob = pijkCyclicVariance(xijk, indices)
% Syntax:
%  pijkCyclicVariance(xijk, indices) Returns the probability that xijk = x 
%  for the CyclicVariance tensor ensemble at index given by indices.
% 
% Input Arguments:
%  - xijk (float)
%    Value of the entry of the tensor at index given by indices
%  
%  - indices (array)
%    Indices of the element in the tensor
% 
% Output Arguments:
%  - prob (float)
%    Probability that xijk = x for the CyclicVariance tensor ensemble. 
% 
% Note: We really only care about the ratio of probabilities for xijk
% changing to another value. Thus, we leave out the normalization
% prefactor. 
%
% Usage:
%
%  Example 1 - Get the permutations of input array.
%
%    pijkCyclicVariance(0.75, [1, 2, 3])

    prob = exp(-xijk^2 / 2 * numPermutations(indices));
end