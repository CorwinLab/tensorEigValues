function newTensor = getIndices(J, varargin)
%GETINDICES Isolate the first x indices in J where x is the length of 
% varargin
sizeJ = size(J);
N = sizeJ(1);
p = length(sizeJ);
inds = repmat({1:N}, 1, p);

for i = 1:length(varargin)
    inds{i} = varargin{i};
end
newTensor = J(inds{:});
end

