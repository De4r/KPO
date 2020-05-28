%% Read image
img = imread('tower.jpg');
imshow(img)
%% Use imageesc()
imagesc(img);
%% Color space
subplot(131);
imagesc(img(:,:,1));
title('Red color');
subplot(132);
imagesc(img(:,:,3));
title('Green color');
subplot(133);
imagesc(img(:,:,3));
title('Blue color');
colormap gray;
%% Multiply color spaces

subplot(211); imshow(img); title('Normal img');
subplot(212); blue_img = double(img);
blue_img(:,:,3) = 4*blue_img(:,:,3);
blue_img = uint8(blue_img);
imshow(blue_img);
title('RG 4*B');

%% Convert to gray scale
img_gray = rgb2gray(img);
imshow(img_gray);

%% Showing histogram
imhist(img_gray);

%% Adjusting histogram
img = imread('Rachmaninoff.jpg');
img_gray = rgb2gray(img);
img_adj = imadjust(img_gray, [0.3 0.7], []);
subplot(121); imshow(img);
subplot(122); imshow(img_adj);

%% Binarizing
bw_img = im2bw(img_adj);
subplot(121);
imshow(img_adj);
title('input image'); 

subplot(122);
imshow(bw_img);
title('binary image'); 
