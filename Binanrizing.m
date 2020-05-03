%% READ IMAGE
clear all
I = imread('mikrostruktura.jpg');
figure(1);
imshow(I);
%% Convert to gray scale
Igray = rgb2gray(I);
imshow(Igray);
%% Bianrizing
level = 0.4;
Itreshholded = im2bw(Igray, level);
imshowpair(I, Itreshholded, 'montage');