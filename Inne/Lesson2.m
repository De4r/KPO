%% Read image, show informations
img = imread('Sun.jpg');
info = imfinfo('Sun.jpg')

%% Saving image as indexed color
[ind, map] = rgb2ind(img, 32);
imagesc(ind);
%% Apply color map
colormap(map);

%% Gray scale
gray = rgb2gray(img);
imshow(gray);
%% Apply jet color map
colormap(jet);
%% Apply spring color map
colormap(spring);