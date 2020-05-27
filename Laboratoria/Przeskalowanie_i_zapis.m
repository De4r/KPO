% Skrypt s³u¿y do przeskalowania zdjêcia do wymaganego rozmiaru
% Zdjecia zapisane w postaci zdj_[numer].jpg
numer = "3";        % numer zdjêcia
zdj_org = "zdj_org" + numer + ".jpg"        % stworzenie nazwy zdj orginal.
zdj = "zdj_" + numer                        % stworzenie nazwy zapisu
img = imread(zdj_org);                      % Wczytanie
info = imfinfo(zdj_org)                     % wyœwietlenie informacji
img = imrotate(img, -90);                   % obrócenie zdjêcia
img_new = imcrop(img, [400 400 2200 3200]);     % Wyciêcie obszaru twarzy
imshowpair(img, img_new, 'montage');        % porównanie wyciêcia

% Jeœli jest ok usuñ znaki komentarza aby wygenerowaæ zdjêcie 768x480 w
% ró¿nych formatach

% img_new = imresize(img_new, [768, 480]);
% imwrite(img_new, zdj + ".jpg");
% imwrite(img_new, zdj + ".bmp");
% imwrite(img_new, zdj + ".tiff");
