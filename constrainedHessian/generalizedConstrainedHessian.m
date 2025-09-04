function hessian = generalizedConstrainedHessian(J, x)
%UNTITLED Summary of this function goes here
%   This does indeed match the p=3 test code!
J = tensor(J);
N = length(x);
p = length(size(J));
hessian = zeros([N-1, N-1]);

% Coerrce x into a column vector
if isrow(x)
    x = x';
end

for alpha=1:N-1
    for beta=1:N-1
        hessian(alpha, beta) = hessian(alpha, beta) ...
            + (p-1) * (ttv(getIndices(J, alpha, beta), x, 1:p-2) ...
            - ttv(getIndices(J, alpha, N), x, 1:p-2) * x(beta) / x(N) ...
            - ttv(getIndices(J, beta, N), x, 1:p-2) * x(alpha) / x(N) ...
            + ttv(getIndices(J, N, N), x, 1:p-2) * x(alpha) * x(beta) / x(N)^2) ...
            - ttv(getIndices(J, N), x, 1:p-1) * x(alpha) * x(beta) / x(N)^3;
        % I've checked that this matches the p=3 code
        if alpha == beta
            hessian(alpha, beta) = hessian(alpha, beta) ...
                - ttv(getIndices(J, N), x, 1:p-1) / x(N);
        end
    end
end
hessian = hessian * p;
end