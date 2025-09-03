function hessian = generalizedConstrainedHessian(J, x, p)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N = length(J);
sizeOfHessian = size(J(:, :, 1)) - 1;
hessian = zeros(sizeOfHessian);
x = transpose(x);

for alpha=1:sizeOfHessian(1)
    for beta=1:sizeOfHessian(2)
        hessian(alpha, beta) = hessian(alpha, beta) + (p-1) * (ttv(getIndices(J, alpha, beta), x', 1));
        if alpha == beta
            hessian(alpha, beta) = hessian(alpha, beta);
        end
    end
end
hessian = p .* hessian;
end