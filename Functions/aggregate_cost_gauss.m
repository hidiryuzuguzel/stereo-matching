% Cost Volume Aggregation with gaussian filtering
% Performs per-slice filtering of input cost volume
%
% Syntax: CostAgg = aggregate_cost_gauss(Cost, radius, simga);
% Cost - input 3D Cost Volume
% radius - radius of square window (size = radius*2 + 1)
% simga - parameter of Gaussian filter
% CostAgg - aggregated cost

function CostAgg = aggregate_cost_gauss(Cost, radius, sigma)


% <write your code here >
W = fspecial('gaussian',radius*2+1,sigma);
for d=1:size(Cost,3)
    CostAgg(:,:,d) = conv2(Cost(:,:,d),W,'same');
end