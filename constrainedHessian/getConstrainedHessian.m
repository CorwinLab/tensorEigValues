function hessian = getConstrainedHessian(J, x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N = length(J);
sizeOfHessian = size(J(:, :, 1)) - 1;
hessian = zeros(sizeOfHessian);
x = transpose(x);

for alpha=1:sizeOfHessian(1)
    for beta=1:sizeOfHessian(2)
        hessian(alpha, beta) = hessian(alpha, beta) + 6 * dot(J(1:end-1, alpha, beta), x(1:end-1)) ...
            + 6 * J(beta, alpha, N) * x(N) - 6 * dot(J(1:end-1, alpha, N), x(1:end-1)) * x(beta) / x(N) ...
            - 6 * dot(J(1:end-1, beta, N), x(1:end-1)) * x(alpha) / x(N) ...
            - 3 * dot(J(1:end-1, 1:end-1, N) * x(1:end-1).', x(1:end-1)) * x(alpha) * x(beta) / x(N)^3 ...
            - 6 * J(alpha, N, N) * x(beta) - 6 * J(beta, N, N) * x(alpha) ...
            + 3 * J(N, N, N) * x(alpha) * x(beta) / x(N);
        if alpha == beta
            hessian(alpha, beta) = hessian(alpha, beta) - 3 * dot(J(1:end-1, 1:end-1, N) * x(1:end-1).', x(1:end-1)) / x(N) ...
                - 6 *dot(J(1:end-1, N, N), x(1:end-1)) - 3 * J(N, N, N) * x(N); 
        end
    end
end
end