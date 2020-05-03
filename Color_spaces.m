%%
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