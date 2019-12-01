% Confidence map computation
% Syntax: [Conf] = comp_confidence(CostVol)
% Where:
% CostVol - input cost volume
% Conf - output confidence mask masks (the same size as input
% disparities)
%
% Algorithm hints:
% for each pixel (y,x)
% find two local minima with the smallest values
% compute their peak ratio (see instructions for formula)

function [Conf] = comp_confidence(CostVol)
Conf = ones( [ size( CostVol, 1), size(CostVol, 2) ]); 

% <write your code here >
for y=1:size( CostVol, 1)
    for x=1:size(CostVol, 2)
        val = sort(reshape(CostVol(y,x,:),size(CostVol,3),1));
        Conf(y,x) = abs(val(2)-val(1))/val(2);
    end
end
