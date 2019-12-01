% Cost Volume Aggregation with block averaging
% Performs per-slice averaging of input cost volume
%
% Syntax: CostAgg = aggregate_cost_block(Cost, radius);
% Cost - input 3D Cost Volume
% radius - radius of square window (size = radius*2 + 1)
% CostAgg - aggregated cost

function CostAgg = aggregate_cost_block(Cost, radius)


% <write your code here >
filter_size = radius*2 + 1;
W = 1/(filter_size*filter_size)*ones(filter_size);   % box filter
for d=1:size(Cost,3)
    CostAgg(:,:,d) = conv2(Cost(:,:,d),W,'same');
end