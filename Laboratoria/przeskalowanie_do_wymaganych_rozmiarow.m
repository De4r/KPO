% Skrypt s³u¿y do przeskalowania zdjêcia do wymaganego rozmiaru

numer = "3";
zdj_org = "zdj_org" + numer + ".jpg"
zdj = "zdj_" + numer
img = imread(zdj_org);
info = imfinfo(zdj_org)
img = imrotate(img, -90);
img = imcrop(img, [400 400 2200 3200]);
% img_new = imresize(img, [768, 480]);

imshowpair(img, img_new, 'montage');
imwrite(img_new, zdj + ".jpg");
imwrite(img_new, zdj + ".bmp");
imwrite(img_new, zdj + ".tiff");
