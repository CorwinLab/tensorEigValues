function energy = getEnergy(J, x)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    x = transpose(x);
    energy = ttv(J, {x, x, x}, [1 2 3]);
end