I = imread('mikrostruktura.jpg');
imshow(I);
I = imadjust(I, stretchlim(I));
figure();
imshow(I);
i = decorrstretch(I, 'Tol', 0.1);
figure()
imshow(i);