
clear;
close all;
clc;

dataset = 'sawtooth'; factor = 8;

%dataset = 'cones'; factor = 4;

%addpath('./pfunctions/');
addpath('./Functions/');

L = imread([dataset,'\im2.ppm']);
R = imread([dataset,'\im6.ppm']);
GTL = single(imread([dataset,'\disp2.pgm']))./factor;

mindisp = 0; %floor(min(GT(:)));
maxdisp = ceil(max(GTL(:)));


[CostL, CostR] = calculate_cost(L, R, mindisp, maxdisp);


%%
% Graphs about effect of radius
radii = 1:10;
names = {'block aggregation', 'gaussian aggregation', 'color-weighted aggregation'};
for radius = radii
    % Block-agg
    CostLa = aggregate_cost_block(CostL, radius);
    [DispLa] = winner_takes_all(CostLa);
    DispLa = DispLa + mindisp;
    ERRORS(radius, 1) = calculate_error(DispLa, GTL);
    clear CostLa;
    
    % Gaussian-agg
    CostLb = aggregate_cost_gauss(CostL, radius, radius/2);
    [DispLb] = winner_takes_all(CostLb);
    DispLb = DispLb + mindisp;
    ERRORS(radius, 2) = calculate_error(DispLb, GTL);
    clear CostLb;
    
    % Color-weighted agg
    CostLc = aggregate_cost_color(single(CostL), L, radius, 10000, radius/2);
    [DispLc] = winner_takes_all(CostLc);
    DispLc = DispLc + mindisp;
    ERRORS(radius, 3) = calculate_error(DispLc, GTL);
    clear CostLc;
    
    
    figure(1); 
    plot(ERRORS, 'LineWidth', 2); 
    title('Aggregation performance'); 
    legend(names); 
    xlabel('Window radius');
    ylabel('BAD pixels (%)');
    drawnow;
    radius
end


