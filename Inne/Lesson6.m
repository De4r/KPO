%% Filtering 
i = imread('hawk.png');
mean_filter = ones(3,3)/sum(sum(ones(3,3)))
i2 = im2double(i);
for n=1:3
    i2(:,:,n) = filter2(mean_filter, i2(:,:,n));
end
subplot(121); imshow(i);
subplot(122); imshow(i2);

%% Low pass filer is used to denoise
i3 = im2double(i);
i3 = imnoise(i3, 'salt & pepper', 0.05);
i3_f = im2double(i3);
for n=1:3
    i3_f(:,:,n) = filter2(mean_filter, i3_f(:,:,n));
end
subplot(121); imshow(i3);
subplot(122); imshow(i3_f);

%% Using median filer
i3_m = i3;
for n=1:3
    i3_m(:,:,n) = medfilt2(i3_m(:,:,n), [5 5]);
end
subplot(131); imshow(i3);
subplot(132); imshow(i3_f);
subplot(133); imshow(i3_m);

%% fspecial - creating pre defined filte rtypes
type = ["average", "disk", "gaussian", "laplacian", "motion", "perwitt", "sobel"];
f = fspecial(type(2), 2);
f2 = fspecial(type(2), 10);
i = uint8(i);
for n=1:3
    i2(:,:,n) = imfilter(i(:,:,n), f, 'replicate');
    i3(:,:,n) = imfilter(i(:,:,n), f2, 'replicate');
end
i2 = uint8(i2); i3 = uint8(i3);
subplot(131); imshow(i);
subplot(132); imshow(i2);
subplot(133); imshow(i3);