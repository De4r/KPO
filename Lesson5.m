%% Histogram eq
i = imread('Unequalized_Hawkes_Bay_NZ.jpg');
subplot(221);imshow(i);
subplot(222);imhist(i);
subplot(223);imshow(histeq(i));
subplot(224);imhist(histeq(i));

%% Adjusting photo
i_adj = imadjust(i, [100/255 225/255],[]);
subplot(221);imshow(i);
subplot(222);imhist(i);
subplot(223);imshow(i_adj);
subplot(224);imhist(histeq(i_adj));