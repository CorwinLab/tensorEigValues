function val = getMinSaddleMax(J, x)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
    constrainedHessian = getConstrainedHessian(J, x);
    eigVals = eig(constrainedHessian);
    if all(eigVals>0)
        val = -1;
    elseif all(eigVals < 0)
        val = 1; 
    else
        val = 0;
    end
end