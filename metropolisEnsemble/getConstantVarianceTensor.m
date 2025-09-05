function J = getConstantVarianceTensor(N)
% Syntax:
%  getConstantVarianceTensor(N) Returns a symtensor object with p=3 and
%  given dimension N. All entries of the tensor are drawn from a standard
%  gaussian distribution
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
%    getConstantVarianceTensor(9)

    J = symtensor(@randn, 3, N);
end