% calculates cost volume out of two images
% Syntax: [CostL, CostR] = calculate_cost(L, R, mindisp, maxdisp);
%
% Where:
% CostL - Cost volume assocuiated with Left image
% CostR - Cost volume assocuiated with Right image
% L, R - Left and Right input images
% mindisp, maxdisp - parameters, limiting disparity 
%
% Algorithm hints:
% for disp = mindisp:maxdisp
%   d = disp-mindisp+1; % matlab indexing starts from unity
%   CostL(y,x,d) = |L(y,x,:)-R(y,x-disp,:)| % (L1 or L2 norm here)
%   CostR(y,x,d) = |R(y,x,:)-L(y,x+disp,:)| 
% end

function [CostLR, CostRL] = calculate_cost(L, R, mindisp, maxdisp)


% <write your code here >
L = double(L);  R = double(R);
CostLR = Inf*ones(size(L,1),size(L,2),maxdisp-mindisp+1);
CostRL = Inf*ones(size(R,1),size(R,2),maxdisp-mindisp+1);
for disp=mindisp:maxdisp
    d = disp-mindisp+1;
    for y=1:size(L,1)
        for x=1+disp:size(L,2)
            CostLR(y,x,d) = norm(reshape(L(y,x,:),3,1)-reshape(R(y,x-disp,:),3,1));
        end
    end 
    
    for y=1:size(L,1)
        for x=1:size(L,2)-disp
            CostRL(y,x,d) = norm(reshape(R(y,x,:),3,1)-reshape(L(y,x+disp,:),3,1));
        end
    end 
end

end