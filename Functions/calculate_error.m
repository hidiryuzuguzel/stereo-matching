% calculates percentage of bad pixels
% (pixels, with error larger than unity)
% 
% Syntax: [err] = calculate_error(Disp, GT)
% 

function [err] = calculate_error(Disp, GT)

%% Please note: 
% using for or while loops in this file is FORBIDDEN
% utilize Matlabs vectorization to perform the calculations
%%
% <write your code here >
N = numel(Disp);                    % total number of pixels
err = 1/N*sum(sum(abs(Disp-GT)>1));