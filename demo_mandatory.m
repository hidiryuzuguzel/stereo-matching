% In this demo: 
% - cost volumes calculation
% - aggregation (with different filters)
% - disparity aqcuisition (winner-takes-all)
% - left-to-right correspondance check
% - occlusion filling

clear;
close all;
clc;
addpath('./Functions/');

%dataset = 'sawtooth'; factor = 8;

dataset = 'cones'; factor = 4;

L = imread([dataset,'\im2.ppm']);
R = imread([dataset,'\im6.ppm']);
GT = single(imread([dataset,'\disp2.pgm']))./factor;

mindisp = 0; %floor(min(GT(:)));
maxdisp = ceil(max(GT(:)));

%figure; imshow(L); title('Left image');
%figure; imshow(R); title('Right image');
%figure; imshow(GT, [mindisp maxdisp]); title('Ground true disparity');

%% cost calculation
% TODO: In the original demo, there is a white stripe on the left of the
% image, while in my result, there are two black stripes on the left and
% right sides of the image
[CostL, CostR] = calculate_cost(L, R, mindisp, maxdisp);
figure; imshow(CostL(:,:,10), []); title('One slice of cost volume');
%% winner-takes-all

[DispL] = winner_takes_all(CostL);
DispL = DispL + mindisp;
figure, imshow(DispL, [mindisp maxdisp]); 
title(['Left disparity estimate without aggregation - Error: ', num2str(calculate_error(DispL, GT))]);

%% block aggregation
CostLa = aggregate_cost_block(CostL, 5);
[DispLa] = winner_takes_all(CostLa);
DispLa = DispLa + mindisp;
figure, imshow(DispLa, [mindisp maxdisp]); 
title(['Left disparity estimate with block-aggregation  - Error: ' num2str(calculate_error(DispLa, GT))]);
clear CostLa;

%% gaussian aggregation
CostLb = aggregate_cost_gauss(CostL, 5, 1);
[DispLb] = winner_takes_all(CostLb);
DispLb = DispLb + mindisp;
figure, imshow(DispLb, [mindisp maxdisp]); 
title(['Left disparity estimate with Gaussian aggregation - Error: ', num2str(calculate_error(DispLb, GT))]);
clear CostLb;

%% Color-weighted agg (Extra)
% CostLc = aggregate_cost_color(single(CostL), L, 5, 10000, 10);
% [DispLc] = winner_takes_all(CostLc);
% DispLc = DispLc + mindisp;
% figure, imshow(DispLc, [mindisp maxdisp]); 
% title(['Left disparity estimate with Color-weighted aggregation - Error: ', num2str(calculate_error(DispLc, GT))]);
% clear CostLc;
 
%%
% Graphs about effect of radius
radii = 1:20;
names = {'Block aggregation', 'Gaussian aggregation'};
for radius = radii
    % Block-agg
    CostLa = aggregate_cost_block(CostL, radius);
    [DispLa] = winner_takes_all(CostLa);
    DispLa = DispLa + mindisp;
    ERRORS(radius, 1) = calculate_error(DispLa, GT);
    clear CostLa;
    
    % Gaussian-agg
    CostLb = aggregate_cost_gauss(CostL, radius, radius/3);
    [DispLb] = winner_takes_all(CostLb);
    DispLb = DispLb + mindisp;
    ERRORS(radius, 2) = calculate_error(DispLb, GT);
    clear CostLb;
    
    
    figure(5); 
    plot(ERRORS, 'LineWidth', 2); 
    title('Aggregation performance'); 
    legend(names); 
    xlabel('Window radius');
    ylabel('BAD pixels (%)');
    drawnow;
    
end


