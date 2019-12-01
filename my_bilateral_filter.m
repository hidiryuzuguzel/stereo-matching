% bilateral filtering
%
% Syntax: filteredImage = bilateral_filter(Image, radius, simga_color,sigma_distance);
% Image - color image corresponding to cost volume
% radius - radius of square window (size = radius*2 + 1)
% simga_color - parameter of range-filter component
% simga_distance - parameter of Gaussian component

function [filteredImage,B] = bilateral_filter(Image, radius, sigma_color, sigma_distance)


% <write your code here >
%Image = cat(3,Image,Image,Image);
Imagehat = padarray(im2double(Image),[radius radius]);
ImagehatLab = applycform(Imagehat, makecform('srgb2lab'));



%W_distance = fspecial('gaussian',radius*2+1,sqrt(sigma_distance/2));
% Pre-compute Gaussian distance weights.
w = radius;
[X,Y] = meshgrid(-w:w,-w:w);
G = exp(-(X.^2+Y.^2)/sigma_distance);

W_distance = zeros(radius*2+1);
for i=1:2*radius+1     
    for j=1:2*radius+1    
        deltag = (radius+1-i)^2 + (radius+1-j)^2;
        W_distance(i,j) = exp(-deltag/sigma_distance);
    end
end
W_color = zeros(radius*2+1);

A = applycform(im2double(Image),makecform('srgb2lab'));
dim = size(Image);
B = zeros(dim);
% apply bilateral filter
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
        factorhat = factor./sum(sum(factor));
        
        filteredImageLab(y,x,1) = sum(sum(ImagehatLab(y:y+2*radius,x:x+2*radius,1).*factorhat));
        filteredImageLab(y,x,2) = sum(sum(ImagehatLab(y:y+2*radius,x:x+2*radius,2).*factorhat));
        filteredImageLab(y,x,3) = sum(sum(ImagehatLab(y:y+2*radius,x:x+2*radius,3).*factorhat));
%         filteredImage(y,x) = sum(sum(Imagehat_gray(y:y+2*radius,x:x+2*radius).*factor));

%%
 % Extract local region.
         iMin = max(y-w,1);
         iMax = min(y+w,dim(1));
         jMin = max(x-w,1);
         jMax = min(x+w,dim(2));
         I = A(iMin:iMax,jMin:jMax,:);
      
         % Compute Gaussian range weights.
         dL = I(:,:,1)-A(y,x,1);
         da = I(:,:,2)-A(y,x,2);
         db = I(:,:,3)-A(y,x,3);
         H = exp(-(dL.^2+da.^2+db.^2)/sigma_color);
      
         % Calculate bilateral filter response.
         F = H.*G((iMin:iMax)-y+w+1,(jMin:jMax)-x+w+1);
         norm_F = sum(F(:));
         B(y,x,1) = sum(sum(F.*I(:,:,1)))/norm_F;
         B(y,x,2) = sum(sum(F.*I(:,:,2)))/norm_F;
         B(y,x,3) = sum(sum(F.*I(:,:,3)))/norm_F;

    end    
end

filteredImage = applycform(filteredImageLab,makecform('lab2srgb'));
B = applycform(B,makecform('lab2srgb'));
figure,
subplot(131), imshow(Image), subplot(132), imshow(filteredImage), subplot(133), imshow(B),

end
