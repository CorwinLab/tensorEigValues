rng(1)

p = 3;
N = 4;

J = symtensor(@randn, p, N);
J = double(full(J));

[lambda, V] = zeig(J);
x = V(:, end);

newBasis = makeOrthoNormalConstraintBasis(x);
JNewBasis = ttm(tensor(J),  {newBasis, newBasis, newBasis}, [1 2 3]);

[lambdaNewBasis, VNewBasis] = zeig(double(JNewBasis));

constrainedHessian = getConstrainedHessian(double(JNewBasis), VNewBasis(:, end));
% [Vnew, Dnew] = eig(constrainedHessian);

display(constrainedHessian);

constrainedHessian = getConstrainedHessianChangedBasis(J, V(:, end));
display(constrainedHessian);
% delta = 1e-6;
% deformedPos = [delta*transpose(Vnew(:, 1)) VNewBasis(end, end)];
% deformedPos = deformedPos / norm(deformedPos);
% deltaEnergy = getEnergy(tensor(JNewBasis), deformedPos, 3) - getEnergy(tensor(JNewBasis), transpose(VNewBasis(:, end)), 3);
% display(1/2 * Dnew(1,1))
% display(deltaEnergy/ delta^2)