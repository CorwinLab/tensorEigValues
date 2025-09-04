function constrainedHessianNewBasis = getConstrainedHessianChangedBasis(J, inputVec)
    % J should be a double matrix
    % Need to do a change of basis for numerical stability
    
    % Get new basis to change to
    newBasis = makeOrthoNormalConstraintBasis(inputVec);
    
    p = length(size(J));

    % Shift the tensor and input vector into this basis
    % We're assuming p=3 here
    newBasisMatrix = cell(1, p);
    newBasisMatrix(:) = {newBasis};

    JNewBasis = ttm(tensor(J),  newBasisMatrix, 1:p);
    vecNewBasis = vectorChangeOfBasis(transpose(inputVec), newBasis);
    
    constrainedHessianNewBasis = generalizedConstrainedHessian(double(JNewBasis), vecNewBasis);

end