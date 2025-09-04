function energy = getEnergy(A, inputVec, p)
%UNTITLED12 Summary of this function goes here
%   Detailed explanation goes here
    inputVec = inputVec.';
    vecs = cell(1, p);
    vecs(:) = {inputVec};
    axes = 1:p;
    energy = double(ttv(full(A), vecs, axes));
end