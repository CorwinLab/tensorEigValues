function A = getCyclicTensor(N)
% Syntax:
%  getConstantVarianceTensor(N) Returns a symtensor object with p=3 and
%  given dimension N. Entries of the tensor are drawn from a gaussian
%  distribution with mean 0 and variance given by 1 / (number of
%  permutations of the tensor indice). For example, diagonal elements have
%  variance 1, off diagonal with indices i!=j!=k have variance 1 / 6. 
% 
% Input Arguments:
%  - N (int)
%    Dimension for the tensor
%
% Output Arguments:
%  - J (symtensor)
%    Symmetric tensor with random entries
% 
% Usage:
%
%  Example 1 - Get a tensor with dimension 9
%
%    getCyclicTensor(9)

    A = symtensor(@ones, 3, N);

    for i=1:N
        for j=1:i
            for k=1:j
                A(i, j, k) = A(i, j, k) / sqrt(numPermutations([i j k]));
            end
        end
    end 
end