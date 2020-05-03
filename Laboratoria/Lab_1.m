% Plik realizuj¹cy wszystkie operacje
clc; clear all; close all;
save_ = 'n'; % jesli generowaæ wykresy to daj 'y'
%% Wczytanie zdjêcia w rozmiarze 768x480
zdj = 'zdj_3.bmp'
i = imread(zdj);
info = imfinfo(zdj)
j = 1;
figure(j);
imagesc(i); title('Obraz orginalny');

%% Zapis w innych formatach
if save_ == 'y'
    imwrite(i, 'zdj.jpg');
    imwrite(i, 'zdj.tiff');
end

%% Przekszta³cenia geometryczne
% skalowanie
i_ = imresize(i, 0.6);

j=j+1; figure(j);
imshowpair(i, i_, 'montage'); title('Skalowanie obrazu');
if save_ == 'y'
    imwrite(i_, 'skalowany.bmp');
end

% obracanie
j=j+1; figure(j);
i_ = imrotate(i, 90, 'bicubic');
imshowpair(i, i_, 'montage'); title('Obracanie obrazu');
if save_ == 'y'
    imwrite(i_, 'obrocony.bmp');
end

% przycinanie

j=j+1; figure(j);
i_ = imcrop(i, [115 125 250 480]);
imshowpair(i, i_, 'montage'); title('Przycinanie obrazu');
if save_ == 'y'
    imwrite(i_, 'przyciety.bmp');
end

% intransform

j=j+1; figure(j);
T = maketform('projective', [1 1; 240 1; 240 250; 1 240], [20, 40; 220 40; 220 250;1 220]);
i_ = imtransform(i, T, 'XYScale', 1);
imshowpair(i, i_, 'montage'); title('Imtransform obrazu');
if save_ == 'y'
    imwrite(i_, 'imtrans.bmp');
end

%% Przekszta³cenia geometryczne
% dodawanie (rozjasnianie)

j=j+1; figure(j);
i_ = imadd(i, 50);
imshowpair(i, i_, 'montage'); title('Rozjasnianie obrazu');
if save_ == 'y'
    imwrite(i_, 'rozjasnianie.bmp');
end

% odejmowanie
j=j+1; figure(j);
i_ = imadd(i, -50);
imshowpair(i, i_, 'montage'); title('Przyciemnianie obrazu');
if save_ == 'y'
    imwrite(i_, 'przyciemnianie.bmp');
end

% mno¿enie
j=j+1; figure(j);
i_ = immultiply(i, 1.25);
imshowpair(i, i_, 'montage'); title('Mnozenie obrazu');
if save_ == 'y'
    imwrite(i_, 'mnozenie.bmp');
end

% dwu-argumentowe operacje
j=j+1; figure(j);
i_ = imadd(i, -50);
i_ = imabsdiff(i, i_);
i_ = imadjust(i_, [0 0.1], [0 1]);
imshowpair(i, i_, 'montage'); title('Operace dwupunktowe');
if save_ == 'y'
    imwrite(i_, 'dwyargumetnowe.bmp');
end

% dodwanie obrazow
j=j+1; figure(j);
i_ = immultiply(i, 1.25);
i_ = imadd(i, i_);
imshowpair(i, i_, 'montage'); title('Dodawnie obrazu');
if save_ == 'y'
    imwrite(i_, 'dodawanie_obrazow.bmp');
end

% modulacja gamma, wyrownanie histogramu
j=j+1; figure(j);
i_ = histeq(i);
imshowpair(i, i_, 'montage'); title('Obraz po wyrównaniu histogramu');
if save_ == 'y'
    imwrite(i_, 'wyrownanie_hist.bmp');
end

j=j+1; figure(j);
subplot(121); imhist(i); title('Histogram obrazu orginalnego');
i_ = imadjust(i, [0.2 0.8], []);
subplot(122); imhist(i_); title('Histogram po modulacji gamma');

% skala szarosci
i_gray = rgb2gray(i);
i_gray = imadjust(i_gray, [0 1], [0 1], 1);
j=j+1; figure(j);
imshowpair(i, i_gray, 'montage'); title('Skala szarosci');
if save_ == 'y'
    imwrite(i_, 'skala_szarosc.bmp');
end

% binaryzacja
j=j+1; figure(j);
i_ = im2bw(i_gray, [110/255]);
imshowpair(i_gray, i_, 'montage'); title('Binaryzacja');
if save_ == 'y'
    imwrite(i_, 'binaryzacja.bmp');
end

% widmo fouriera
i_ = fftshift(fft2(i_gray));
i_ = abs(i_); i_ = 255*i_/max(max(i_));
j=j+1; figure(j);
imshowpair(i_gray, i_, 'montage'); title('FFT');
if save_ == 'y'
    imwrite(i_, 'FFT.bmp');
end

%% Filtracja
% dolnoprzepustowy
j=j+1; figure(j);
filtr = ones(7);
filtr = filtr/sum(sum(filtr));
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title('Filtr dolnoprzepusowy');
if save_ == 'y'
    imwrite(i_, 'dolnoprzepustowy.bmp');
end

% wlasny
j=j+1; figure(j);
filtr = [ 2 4 2; 4 8 4; 2 4 2];
filtr = filtr/sum(sum(filtr));
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title('Filtr wlasny');
if save_ == 'y'
    imwrite(i_, 'filtr_wlasny.bmp');
end

% gornoprzepustowy
j=j+1; figure(j);
filtr = [ 0 0 0; -1 0 0; 0 1 0];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Filtr gornoprzepustowy');
if save_ == 'y'
    imwrite(i_, 'filtr_gornoprzepustowy1.bmp');
end
i_2 = imfilter(i, rot90(filtr)); i_2 = imadjust(i_2, stretchlim(i_2));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Filtr gornoprzepustowy odwrocony');
if save_ == 'y'
    imwrite(i_, 'filtr_gornoprzepustowy2.bmp');
end

% suma gradientow
j=j+1; figure(j);
i_ = imadd(i_, i_2);
imshowpair(i, i_, 'montage'); title('Suma filtrow gornoprzepustowych');
if save_ == 'y'
    imwrite(i_, 'suma_filtrow_gorno.bmp');
end

% gradniet robertsa
j=j+1; figure(j);
filtr = [ -1 -1 -1; 0 0 0; 1 1 1];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Filtr Robertsa');
if save_ == 'y'
    imwrite(i_, 'filtr_robertsa.bmp');
end
i_ = imfilter(i, rot90(filtr)); i_ = imadjust(i_, stretchlim(i_));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Filtr Robertsa odwrocony');
if save_ == 'y'
    imwrite(i_, 'filtr_robertsa_2.bmp');
end

%maski Sobela
j=j+1; figure(j);
filtr = [ -1 -2 -1; 0 0 0; 1 2 1];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Maska Sobela');
if save_ == 'y'
    imwrite(i_, 'maska_sobela.bmp');
end
i_ = imfilter(i, rot90(filtr)); i_ = imadjust(i_, stretchlim(i_));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Maska Sobela odwrocona');
if save_ == 'y'
    imwrite(i_, 'maska_sobela_2.bmp');
end

%maski Prewitta
j=j+1; figure(j);
filtr = [ -1 1 -1; 0 0 0; 1 1 1];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Maska Prewitta');
if save_ == 'y'
    imwrite(i_, 'maska_prewitta.bmp');
end

%Laplacjan
j=j+1; figure(j);
filtr = [ 0 -1 0; -1 4 -1; 0 -1 0];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Laplasjan');
if save_ == 'y'
    imwrite(i_, 'lapacjan.bmp');
end

% filtr specjalny Unsharp
j=j+1; figure(j);
filtr = fspecial('unsharp');
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title("Filtr 'Unsharp'");
if save_ == 'y'
    imwrite(i_, 'unsharp.bmp');
end

% filtr specjalny average
j=j+1; figure(j);
filtr = fspecial('average');
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title("Filtr 'Average'");
if save_ == 'y'
    imwrite(i_, 'average.bmp');
end

% filtr medianowy
j=j+1; figure(j);
i_n = im2double(i);
i_n = imnoise(i_n, 'salt & pepper', 0.025);
i_1 = i_n;
for n=1:3
    i_1(:,:,n) = medfilt2(i_n(:,:,n), [3 3]);
end
imshowpair(i_n, i_1, 'montage'); title("Obraz zak³ócony oraz po filtracji medianowej");
if save_ == 'y'
    imwrite(i_1, 'med2filt.bmp');
end

%% Operacje morfologiczne
% erozja
i_bw = im2bw(i_gray, [110/255]);

j=j+1; figure(j);
se = strel('line', 3, 15);
i_ = imerode(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Erozja - element liniowy");
if save_ == 'y'
    imwrite(i_, 'erode_line.bmp');
end

j=j+1; figure(j);
se = strel('disk', 2);
i_ = imerode(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Erozja - element dyskowy");
if save_ == 'y'
    imwrite(i_, 'erode_disc.bmp');
end

% dylatacja
j=j+1; figure(j);
se = strel('line', 3, 15);
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element liniowy");
if save_ == 'y'
    imwrite(i_, 'dilate_line.bmp');
end

j=j+1; figure(j);
se = strel('disk', 2);
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element dyskowy");
if save_ == 'y'
    imwrite(i_, 'dilate_disc.bmp');
end

j=j+1; figure(j);
se = strel('arbitrary', ones(4));
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element 'arbitrary'");
if save_ == 'y'
    imwrite(i_, 'dilate_arb.bmp');
end

% scienanie
i_ = bwmorph(i_bw, 'remove');
j=j+1; figure(j);
imshowpair(i_bw, i_, 'montage'); title("Scienianie'");
if save_ == 'y'
    imwrite(i_, 'scienianie1.bmp');
end

% szkieletyzacja
i_ = bwmorph(i_bw, 'skel');
j=j+1; figure(j);
imshowpair(i_bw, i_, 'montage'); title("Szkieletyzacja");
if save_ == 'y'
    imwrite(i_, 'skeleton.bmp');
end

%% centroidy

i_bw = im2bw(i_gray, [110/255]);
se = strel('disk', 2);
i_ = imerode(i_bw, se);
i_ = imdilate(i_, se);


i_ = bwmorph(i_, 'remove');
i_ = bwmorph(i_, 'shrink');
j=j+1; figure(j);
imshowpair(i_bw, i_, 'montage'); title("Centroidy na otwarciu obrazu");
if save_ == 'y'
    imwrite(i_, 'centroids.bmp');
end
