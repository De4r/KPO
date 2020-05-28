%%
clear all;
I = imread('mikrostruktura.jpg');
imshow(I);
%% RGB color space
rmat = I(:,:,1);
gmat = I(:,:,2);
bmat = I(:,:,3);


subplot(2,2,1); imshow(rmat);
title('Red');
subplot(2,2,2); imshow(gmat);
title('green');
subplot(2,2,3); imshow(bmat);
title('blue');
subplot(2,2,4); imshow(I);
title('orginal');

%% Thresh hodling on each layer

levelr = 0.63;
levelg = 0.5;
levelb = 0.4;

i1=im2bw(rmat, levelr);
i2=im2bw(gmat, levelg);
i3=im2bw(bmat, levelb);

Isum = (i1&i2&i3);

%plots
subplot(2,2,1); imshow(i1);
title('Red');
subplot(2,2,2); imshow(i2);
title('green');
subplot(2,2,3); imshow(i3);
title('blue');
subplot(2,2,4); imshow(Isum);
title('SUM');

%% Invernt background
close;
Icomp = imcomplement(Isum);
Ifilled = imfill(Icomp, 'holes');
figure;
imshow(Ifilled);

%% SE
se = strel('disk', 5);
Iopenned = imopen(Ifilled, se);
imshow(Iopenned);
%%

Iregion = regionprops(Iopenned, 'centroid');
[labeled, numObj] = bwlabel(Iopenned, 4);
stats = regionprops(labeled,'Eccentricity','Area','BoundingBox');
areas = [stats.Area];
eccentricies = [stats.Eccentricity];

%% Use analis
idxOf = find(eccentricies);
statsDef = stats(idxOf);

imshow(I);
hold on;
for idx=1: length(idxOf);
    h = rectangle('Position', statsDef(idx).BoundingBox, 'LineWidth', 2);
    set(h, 'EdgeColor', [0.75 0 0]);
    hold on;
end
if idx > 10
    title(['There are', num2str(numObj), ' objects in the image!']);
else
    title(['There are', num2str(numObj), ' objects in the image ?']);
end
hold off;