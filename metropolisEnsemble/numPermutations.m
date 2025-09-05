function count = numPermutations(arr)
% Syntax:
%  numPermutations(arr) Returns the number of unique permutations of the 
%  input array
% 
% Input Arguments:
%  - arr (array)
%    Array of integers
%
% Usage:
%
%  Example 1 - Get the permutations of input array.
%
%    numPermutations([1, 2, 2])

    [~, numUnique] = count_unique(arr);
    count = factorial(length(arr));

    count = count / prod(factorial(numUnique));
end