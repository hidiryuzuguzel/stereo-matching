% Finds disparity map from Cost Volume
% Syntax: [Disp] = winner_takes_all(Cost)
% Hints:
% for each (y,x) find z-coordinate with the lowest cost value
% (note that matlab coordinates starts from 1, hence we need substract that unity)

function [Disp] = winner_takes_all(Cost)

% <write your code here >
for y=1:size(Cost,1)
    for x=1:size(Cost,2)
        [~,Disp(y,x)] = min(Cost(y,x,:));
    end
end