% Plik realizuj¹cy wszystkie operacje z wyk³adów i przyk³adu
clc; clear all; close all;
save_ = 'y'; % jesli generowaæ wykresy to daj 'y'
%% Wczytanie zdjêcia w rozmiarze 768x480
zdj = 'zdj_3.bmp'
i = imread(zdj);
% Wyœwietlenie informacji o zdjêciu
info = imfinfo(zdj)
j = 1;
% Pokazanie zdjêcia
figure(j);
imagesc(i); title('Obraz orginalny');

%% Zapis w innych formatach
if save_ == 'y'
%     imwrite(i, 'zdj.jpg');
%     imwrite(i, 'zdj.tiff');
end

%% Przekszta³cenia geometryczne
% Skalowanie, funkcja resize(obraz, skala)
i_ = imresize(i, 0.6);

j=j+1; figure(j);
imshowpair(i, i_, 'montage'); title('Skalowanie obrazu');
if save_ == 'y'
    imwrite(i_, 'skalowany.bmp');
end

% Obracanie obrazu, funkcja imrotate(obraz, stopnie, metoda aproks)
j=j+1; figure(j);
i_ = imrotate(i, 90, 'bicubic');
imshowpair(i, i_, 'montage'); title('Obracanie obrazu');
if save_ == 'y'
    imwrite(i_, 'obrocony.bmp');
end

% Przycinanie obrazu, imcrop(obraz, [x y szer wys])

j=j+1; figure(j);
i_ = imcrop(i, [115 125 250 480]);
imshowpair(i, i_, 'montage'); title('Przycinanie obrazu');
if save_ == 'y'
    imwrite(i_, 'przyciety.bmp');
end

% Imtransform, funkcja imtransform(obraz, transfromacja, pozostale opcje)
% transformacja mo¿e byæ utworzona np. za pomoc¹ maketform

j=j+1; figure(j);
T = maketform('projective', [1 1; 240 1; 240 250; 1 240], [20, 40; 220 40; 220 250;1 220]);
i_ = imtransform(i, T, 'XYScale', 1);
imshowpair(i, i_, 'montage'); title('Imtransform obrazu');
if save_ == 'y'
    imwrite(i_, 'imtrans.bmp');
end

%% Przekszta³cenia punktowe
% Dodawanie (rozjasnianie) sta³ej do obrazu
% Funkcja imadd(obraz, wartoœæ)
j=j+1; figure(j);
i_ = imadd(i, 50);
imshowpair(i, i_, 'montage'); title('Rozjasnianie obrazu');
if save_ == 'y'
    imwrite(i_, 'rozjasnianie.bmp');
end

% Odejmowanie (przyciemnianie) sta³ej do obrazu
% Funkcja imadd(obraz, -wartoœæ)
j=j+1; figure(j);
i_ = imadd(i, -50);
imshowpair(i, i_, 'montage'); title('Przyciemnianie obrazu');
if save_ == 'y'
    imwrite(i_, 'przyciemnianie.bmp');
end

% Mno¿enie przez sta³¹
% Funkcja immultiply(obraz, wartoœæ)
j=j+1; figure(j);
i_ = immultiply(i, 1.25);
imshowpair(i, i_, 'montage'); title('Mnozenie obrazu');
if save_ == 'y'
    imwrite(i_, 'mnozenie.bmp');
end

% Dwu-argumentowe operacje np. odejmowanie obrazów
% imabsdiff(obraz, obraz), imadjust(obraz, zakres hist, nowy zakres)
j=j+1; figure(j);
i_ = imread('tower.jpg');
i_ = imresize(i_, [768, 480]);
i_ = imabsdiff(i, i_);
i_ = imadjust(i_, []);

imshowpair(i, i_, 'montage'); title('Operacje dwupunktowe - odejmowanie');
if save_ == 'y'
    imwrite(i_, 'dwuargumetnowe.bmp');
end

% Dodwanie obrazow, imadd(obraz, obraz)
j=j+1; figure(j);
i_ = imread('tower.jpg');
i_ = imresize(i_, [768, 480]);
i_ = imadd(i, i_);
imshowpair(i, i_, 'montage'); title('Dodawnie obrazu');
if save_ == 'y'
    imwrite(i_, 'dodawanie_obrazow.bmp');
end

% Modulacja gamma- wyrownanie histogramu, histeq(obraz)
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

% Skala szarosci, funkcja rgb2gray(obrazRGB)
i_gray = rgb2gray(i);
i_gray = imadjust(i_gray, [0 1], [0 1], 1);
j=j+1; figure(j);
imshowpair(i, i_gray, 'montage'); title('Skala szarosci');
if save_ == 'y'
    imwrite(i_gray, 'skala_szarosc.bmp');
end

% Binaryzacja, im2bw lub imbinarize(obrazGRAY, poziom)
j=j+1; figure(j);
i_ = im2bw(i_gray, [110/255]);
imshowpair(i_gray, i_, 'montage'); title('Binaryzacja');
if save_ == 'y'
    imwrite(i_, 'binaryzacja.bmp');
end

%% TRansformacje obrazow
% Widmo Fouriera z obrazu, funkcja fft2(obraz) oraz fftshift do zamiany
% æwiartek
i_ = fftshift(fft2(i_gray));
i_ = abs(i_); i_ = 255*i_/max(max(i_));
j=j+1; figure(j);
imshowpair(i_gray, i_, 'montage'); title('FFT');
if save_ == 'y'
    imwrite(i_, 'FFT.bmp');
end

%% Filtracja obrazów
% imfilter(obraz, maska)
% Dolnoprzepustowy
j=j+1; figure(j);
filtr = ones(7);
filtr = filtr/sum(sum(filtr));
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title('Filtr dolnoprzepusowy');
if save_ == 'y'
    imwrite(i_, 'dolnoprzepustowy.bmp');
end

% Wlasny
j=j+1; figure(j);
filtr = [ 2 4 2; 4 8 4; 2 4 2];
filtr = filtr/sum(sum(filtr));
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title('Filtr wlasny');
if save_ == 'y'
    imwrite(i_, 'filtr_wlasny.bmp');
end

% Górnoprzepustowy
% Gradniet robertsa
j=j+1; figure(j);
filtr = [ 0 0 0; -1 0 0; 0 1 0];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Filtr gornoprzepustowy');
if save_ == 'y'
    imwrite(i_, 'filtr_gornoprzepustowy1.bmp');
end
% Odwrocony
i_2 = imfilter(i, rot90(filtr)); i_2 = imadjust(i_2, stretchlim(i_2));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Filtr gornoprzepustowy odwrocony');
if save_ == 'y'
    imwrite(i_2, 'filtr_gornoprzepustowy2.bmp');
end

% Suma gradientow powy¿ej
j=j+1; figure(j);
i_ = imadd(i_, i_2);
imshowpair(i, i_, 'montage'); title('Suma filtrow gornoprzepustowych');
if save_ == 'y'
    imwrite(i_, 'suma_filtrow_gorno.bmp');
end

% Maska Prewitta
j=j+1; figure(j);
filtr = [ -1 -1 -1; 0 0 0; 1 1 1];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Maska Prewitta');
if save_ == 'y'
    imwrite(i_, 'filtr_prewitta.bmp');
end
% Odwrócona
i_2 = imfilter(i, rot90(filtr)); i_2 = imadjust(i_2, stretchlim(i_2));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Filtr Prewitta odwrocony');
if save_ == 'y'
    imwrite(i_2, 'filtr_prewitta_2.bmp');
end
% Suma gradientow powy¿ej
j=j+1; figure(j);
i_ = imadd(i_, i_2);
imshowpair(i, i_, 'montage'); title('Suma filtrow Prewitta');
if save_ == 'y'
    imwrite(i_, 'suma_filtrow_prewitta.bmp');
end


% Maska Sobela
j=j+1; figure(j);
filtr = [ -1 -2 -1; 0 0 0; 1 2 1];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Maska Sobela');
if save_ == 'y'
    imwrite(i_, 'maska_sobela.bmp');
end
i_2 = imfilter(i, rot90(filtr)); i_2 = imadjust(i_2, stretchlim(i_2));
j=j+1; figure(j);
imshowpair(i, i_2, 'montage'); title('Maska Sobela odwrocona');
if save_ == 'y'
    imwrite(i_2, 'maska_sobela_2.bmp');
end


% Laplacjan
j=j+1; figure(j);
filtr = [ 0 -1 0; -1 4 -1; 0 -1 0];
i_ = imfilter(i, filtr); i_ = imadjust(i_, stretchlim(i_));
imshowpair(i, i_, 'montage'); title('Laplasjan');
if save_ == 'y'
    imwrite(i_, 'lapacjan.bmp');
end

% Filtr specjalny Unsharp, funkcja fspecial(opcje)
j=j+1; figure(j);
filtr = fspecial('unsharp');
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title("Filtr 'Unsharp'");
if save_ == 'y'
    imwrite(i_, 'unsharp.bmp');
end

% Filtr specjalny average
j=j+1; figure(j);
filtr = fspecial('average');
i_ = imfilter(i, filtr);
imshowpair(i, i_, 'montage'); title("Filtr 'Average'");
if save_ == 'y'
    imwrite(i_, 'average.bmp');
end

% Filtr medianowy
j=j+1; figure(j);
i_n = im2double(i);
% funkcja zaszumiaj¹ca imnoise(obraz, metoda, poziom)
i_n = imnoise(i_n, 'salt & pepper', 0.025);
i_1 = i_n;
for n=1:3
    % Filtracja kana³u za pomoc¹ filtru medianowego z podana maska
    i_1(:,:,n) = medfilt2(i_n(:,:,n), [3 3]);
end
imshowpair(i_n, i_1, 'montage'); title("Obraz zak³ócony oraz po filtracji medianowej");
if save_ == 'y'
    imwrite(i_1, 'med2filt.bmp');
    imwrite(i_n, 'saltandpeper.bmp');
end

%% Operacje morfologiczne
% Binaryzacja
i_bw = im2bw(i_gray, [110/255]);

% Erozja, imerode(obraz, element strukt.)
% strel(opcja, wymiary) - tworzenie elementu strukt.
% Erozja elementem liniowym
j=j+1; figure(j);
se = strel('line', 15, 1);
i_ = imerode(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Erozja - element liniowy");
if save_ == 'y'
    imwrite(i_, 'erode_line.bmp');
end

% Erozja elementem dyskowym
j=j+1; figure(j);
se = strel('disk', 2);
i_ = imerode(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Erozja - element dyskowy");
if save_ == 'y'
    imwrite(i_, 'erode_disc.bmp');
end

% Dylatacja, imdilate(obraz, elem. struk.)
% Element linowy
j=j+1; figure(j);
se = strel('line', 3, 15);
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element liniowy");
if save_ == 'y'
    imwrite(i_, 'dilate_line.bmp');
end

% Element dyskowy
j=j+1; figure(j);
se = strel('disk', 2);
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element dyskowy");
if save_ == 'y'
    imwrite(i_, 'dilate_disc.bmp');
end

% Element z podana maska
j=j+1; figure(j);
se = strel('arbitrary', ones(4));
i_ = imdilate(i_bw, se);
imshowpair(i_bw, i_, 'montage'); title("Dylatacja - element 'arbitrary'");
if save_ == 'y'
    imwrite(i_, 'dilate_arb.bmp');
end

% Otwarcie
j=j+1; figure(j);
se = strel('disk', 2);
i_ = imerode(i_bw, se);
i_ = imdilate(i_, se);

imshowpair(i_bw, i_, 'montage'); title("Otwarcie'");
if save_ == 'y'
    imwrite(i_, 'open_disc.bmp');
end

% Zamkniecie
j=j+1; figure(j);
se = strel('disk', 2);
i_ = imdilate(i_bw, se);
i_ = imerode(i_, se);

imshowpair(i_bw, i_, 'montage'); title("Zakmniêcie");
if save_ == 'y'
    imwrite(i_, 'close_disc.bmp');
end

% Scienanie, bwmorph(obraz, 'remove') - pozostawia kontury
i_ = bwmorph(i_bw, 'remove');
j=j+1; figure(j);
imshowpair(i_bw, i_, 'montage'); title("Scienianie'");
if save_ == 'y'
    imwrite(i_, 'scienianie1.bmp');
end

% Szkieletyzacja,  bwmorph(obraz, 'skel') - pozostawia po³¹czenia œrodków
% obiektów
i_ = bwmorph(i_bw, 'skel', 10);
j=j+1; figure(j);
imshowpair(i_bw, i_, 'montage'); title("Szkieletyzacja");
if save_ == 'y'
    imwrite(i_, 'skeleton1.bmp');
end

% Operacje bothati tophat
i_ = imtophat(i_gray, strel('disk', 4));

i_ = imadjust(i_, stretchlim(i_));
j=j+1; figure(j);
imshowpair(i_gray, i_, 'montage'); title("operacja bothat");
if save_ == 'y'
    imwrite(i_, 'bothat.bmp');
end

i_ = imbothat(i_gray, strel('disk', 4));
i_ = imadjust(i_, stretchlim(i_));

j=j+1; figure(j);
imshowpair(i_gray, i_, 'montage'); title("operacja tophat");
if save_ == 'y'
    imwrite(i_, 'tophat.bmp');
end

%% Centroidy
% Binaryzacja
i_bw = im2bw(i_gray, [110/255]);

i_1 = bwmorph(i_bw, 'shrink', inf);
i_2 = bwmorph(i_bw, 'remove');
i_3 = logical(imadd(i_1, i_2));
j=j+1; figure(j);
imshowpair(i_1, i_2, 'montage'); title("Shirnk i remove");
j=j+1; figure(j);
imshowpair(i_bw, i_3, 'montage'); title("Centrodiy");
if save_ == 'y'
    imwrite(i_3, 'centroids1.bmp');
end
