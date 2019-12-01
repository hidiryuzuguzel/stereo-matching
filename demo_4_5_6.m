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
GT = single(imread([dataset,'\disp6.pgm']))./factor;

mindisp = 0; %floor(min(GT(:)));
maxdisp = ceil(max(GT(:)));

%figure; imshow(L); title('Left image');
%figure; imshow(R); title('Right image');
%figure; imshow(GT, [mindisp maxdisp]); title('Ground true disparity');


%% cost calculation
[CostL CostR] = calculate_cost(L, R, mindisp, maxdisp);


%% gaussian aggregation
CostLb = aggregate_cost_gauss(CostL, 5, 1);
[DispLb] = winner_takes_all(CostLb);
DispLb = DispLb + mindisp;

CostRb = aggregate_cost_gauss(CostR, 5, 1);
[DispRb] = winner_takes_all(CostRb);
DispRb = DispRb + mindisp;

figure; 
avgerror = mean( [calculate_error(DispLb, GT), calculate_error(DispRb, GT)]);
subplot(211); imshow(DispLb, [mindisp maxdisp]);
title(['Disparity estimate with Gaussian aggregation - Error: ' num2str(avgerror) ]);
subplot(212); imshow(DispRb, [mindisp maxdisp]); 


clear CostLb;




%% Left-to-Right correspondance check
[OcclL OcclR] = ltr_check(DispLb, DispRb, 1);

if ( nnz( OcclL ) == 0 && nnz( OcclR ) == 0  )
    disp('Seems like the occlusion map has no content.')
else
    figure; imshow(OcclL, [0 1]); title('Left occlusions');
end

%% Confidence analysis 
[ConfL ] = comp_confidence(CostL);
[ConfR ] = comp_confidence(CostR);
% [ConfL ] = comp_confidence(DispLb);
% [ConfR ] = comp_confidence(DispRb);
if ( sum( ConfL(:) ) == numel( ConfL ) && sum( ConfR(:) ) == numel( ConfR )  )
    disp('Seems like the confidence map has no content.')
else
    figure; imshow(ConfL, [0 1]); title('Left view occlusions');
end

%% Occlusion Filling
% TODO: Ask TA!!!
% DispLc_hat = fill_occlusions(DispLc, OcclL, ConfL);
DispLc_hat = fill_occlusions(DispLb, OcclL, ConfL);
figure; imshow(DispLc_hat, [mindisp maxdisp]); title('Occlusion compensated left disparity');
disp(['error: ', num2str(calculate_error(DispLc_hat, GT))]);


