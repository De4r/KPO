%% Convert rgb to gary scale
i = imread('tower.jpg');
i_gray = 0.2989*i(:,:,1) + 0.5870*i(:,:,2) + 0.1140*i(:,:,3);
imshowpair(i, i_gray, 'montage');

%% Creating gray scale image
h = 240; w = 4/3*h;
white = uint8(255*ones(h,w));
black = uint8(zeros(h,w));

subplot(121); imshow(white);
subplot(122); imshow(black);

%% Camera man
imfinfo('cameraman.tif')
i = imread('cameraman.tif');
[X, map] = gray2ind(i, 16);
size(map)
imshow(X, map);

%% Others color maps
[X, map] = gray2ind(i, 256);

subplot(121); imshow(X, map);
subplot(122); imshow(X, jet(256));