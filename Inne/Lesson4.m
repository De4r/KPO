%% Read image and scale it to double
img = imread('cameraman.tif');
img_im2d = im2double(img);
imshow(img_im2d); % imshow takes 0-255 uint8 or 0,1 double

%% Excrating bit plane

img_d = double(img);
bp0 = mod(img_d, 2);
imshow(bp0);
%% next bit plane
bp1 = mod(floor(img_d/2), 2);
imshow(bp1);

%% all bit planes for 8 bit scale
bp = zeros(size(img_d));
for i=0:7
   bp(:,:,i+1) = mod(floor(img_d/2^i), 2);
   subplot(2,4,i+1); imshow(bp(:,:,i+1)); title(['Bit plane: ' num2str(i) ]);
end

%% Merge all bitplanes
bp_all = 2*(2*(2*(2*(2*(2*(2*bp(:,:,8)+bp(:,:,7))+bp(:,:,6))+bp(:,:,5))+bp(:,:,4))+bp(:,:,3))+bp(:,:,2))+bp(:,:,1);
imshow(uint8(bp_all))