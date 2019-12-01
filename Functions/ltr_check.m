% Left-to-right correspondance check
% Syntax: [OcclL OcclR] = ltr_check(DispL, DispR, threshold)
% Where:
% DispL, DispR - input disparity images
% OcclL, OcclR - output occlusion masks (the same size as input
% disparities)
%
% Algorithm hints:
% for each pixel (y,x)
% find coordinate which correspond to this pixel in right image
% xR = (x - DispL(y,x)); 
% check, if left disparity value in current pixel not differ with
% corresponding right disparity 
% OcclL(y,x) = abs(DispL(y,x)-DispR(y,xR)) < threshold
% similar processing for finding OcclR

function [OcclL OcclR] = ltr_check(DispL, DispR, threshold)
OcclL = zeros(size(DispL)); OcclR = zeros(size(DispR));

% <write your code here >
for y=1:size(DispL,1)
    for x=1:size(DispL,2)
        xR = x - DispL(y,x);    xL = x - DispR(y,x);
        if xR > 0
            OcclL(y,x) = abs(DispL(y,x)-DispR(y,xR)) < threshold;
        end
        if xL > 0
            OcclR(y,x) = abs(DispL(y,xL)-DispR(y,x)) < threshold;
        end
    end
end
