% Color-weighted Cost Volume Aggregation
% Performs per-slice cross-bilateral filtering of input cost volume
%
% Syntax: CostAgg = aggregate_cost_color(Cost, Image, radius, simga_color,
% sigma_distance);
% Cost - input 3D Cost Volume
% Image - color image corresponding to cost volume
% radius - radius of square window (size = radius*2 + 1)
% simga_color - parameter of range-filter component
% simga_distance - parameter of Gaussian component
% CostAgg - aggregated cost

function CostAgg = aggregate_cost_color(Cost, Image, radius, sigma_color, sigma_distance)


% <write your code here >
Costhat = padarray(im2double(Cost),[radius radius]);
Imagehat = padarray(im2double(Image),[radius radius]);
ImagehatLab = applycform(Imagehat, makecform('srgb2lab'));

% W_distance = fspecial('gaussian',radius*2+1,sqrt(sigma_distance/2));
W_distance = zeros(radius*2+1);
for i=1:2*radius+1     
    for j=1:2*radius+1    
        deltag = (radius+1-i)^2 + (radius+1-j)^2;
        W_distance(i,j) = exp(-deltag/sigma_distance);
    end
end
W_color = zeros(radius*2+1);

for y=1:size(Image,1)                       % loop over image height
    for x=1:size(Image,2)                   % loop over image width 
        for i=1:2*radius+1                  % loop over kernel height
            for j=1:2*radius+1              % loop over kernel width
                deltacolor = sum((reshape(ImagehatLab(y+radius,x+radius,:),3,1)-reshape(ImagehatLab(y+i-1,x+j-1,:),3,1)).*...
                    (reshape(ImagehatLab(y+radius,x+radius,:),3,1)-reshape(ImagehatLab(y+i-1,x+j-1,:),3,1)));
                W_color(i,j) = exp(-deltacolor/sigma_color);
            end
        end
%         W_color = W_color./sum(sum(W_color));
        factor = W_distance.*W_color;
        factor = factor./sum(sum(factor));
        
        for d=1:size(Cost,3)
            tmp_cost = Costhat(:,:,d);
            CostAgg(y,x,d) = sum(sum(tmp_cost(y:y+2*radius,x:x+2*radius).*factor));
        end
    end
    y
end

end
