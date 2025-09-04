function newBasis = makeOrthoNormalConstraintBasis(vec)
% Originalbasis has entries [:,i] that are the basis vectors
% constraintVectors has shape (n,k) of column vectors
originalBasis = eye(length(vec));
newBasis = originalBasis;
newBasis(:, 1) = vec;
[newBasis, ~] = qr(newBasis);
newBasis = transpose(newBasis);
newBasis = circshift(newBasis, -1, 1);
end