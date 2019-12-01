% Filling occlusions in disparity image
% (appropriate for left disparity)
%
% Syntax: [Disp] = fill_occlusions(DispL, OcclL, ConfL)
% Where:
% DispL - input disparity image
% OcclL - occlusion map (forund with left-to-right correspondance check)
% ConfL - confidence map
% Disp - output, occlusion-compensated disparity image
%
% Algorithm hint:
% for each pixel (y,x) 
%   if pixel is not occluded - copy its' original value and go forward
%   if pixel occluded or has low confidence
%       find neighbourhood in disparity image (A) with some radius
%       exclude occluded pixels from A
%       set compensated pixel value to be median of A
%       to use "prediction", update occlusion mask as not-occluded
%
% To minimize error propagation left disparity image must be processed directionally:
% from left to right
% Also, special care should be applied to left-most part of image, it's
% usually contain completely erroneous disparity 


function [Disp] = fill_occlusions(DispL, OcclL, ConfL)


% <write your code here >
threshold = 0.01;
masksize = 3;
A = DispL;
%A(OcclL==0) = NaN;
A = padarray(A,[(masksize-1)/2 (masksize-1)/2],'replicate');    % augmented DispL

% TODO: Can we make it faster ?
for y=1:size(DispL,1)
    for x=1:size(DispL,2)
        OcclL_augmented = padarray(OcclL,[(masksize-1)/2 (masksize-1)/2],'replicate');
        if ~OcclL(y,x) || ConfL(y,x) < threshold   % if pixel occluded or has low confidence
            for i=y+1-(masksize-1)/2:y+1+(masksize-1)/2
                for j=x+1-(masksize-1)/2:x+1+(masksize-1)/2
                    if ~OcclL_augmented(i,j)
                        A(i,j) = NaN;       % set occluded pixels to NaNs
                    end
                end
            end
           % neighbourhood window
            w = A(y+1-(masksize-1)/2:y+1+(masksize-1)/2,x+1-(masksize-1)/2:x+1+(masksize-1)/2);
            w = w(:); 
            w(isnan(w)) = [];                   % exclude occluded pixel from window
            Disp(y,x) = median(w);              % set compensated pixel value to be median of window
            OcclL(y,x) = 1;                     % update occlusion mask as not-occluded
        elseif OcclL(y,x)                       % if pixel is not occluded
            Disp(y,x) = DispL(y,x);
        end
    end
    y
end