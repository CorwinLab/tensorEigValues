function [] = getEigVals(dir, sysID, seed, p, N, numSamples)
%GETEIGVALS Summary of this function goes here
%   Detailed explanation goes here
mkdir(dir);

N = str2num(N);
p = str2num(p);
numSamples = str2num(numSamples);

rng(str2num(seed));

for i=1:numSamples
    J = symtensor(@randn, p, N);
    J = double(full(J));
    
    s = rng;
    [energies, V] = zeig(J);
    rng(s);
    
    % Get maximum eigenvectors
    maxVector = V(:, end);
    
    hess = getConstrainedHessianChangedBasis(J, maxVector);
    hessEigs = eig(hess);
    fileName = sprintf("%s/MaxEigenValuesId%sNum%i.txt", dir, sysID, i);
    writematrix(hessEigs, fileName);

    % Get middle eigenvectors
    for j=ceil(length(energies) / 2+1):length(energies)-1
        hess = getConstrainedHessianChangedBasis(J, V(:, j));
        hessEigs = eig(hess);
        if all(hessEigs < 0)
            fileName = sprintf("%s/Typical%iEigenValuesId%sNum%i.txt", dir, j, sysID, i);
            writematrix(hessEigs, fileName);
        end
    end
end

