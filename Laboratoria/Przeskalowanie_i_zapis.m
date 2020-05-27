% Skrypt s�u�y do przeskalowania zdj�cia do wymaganego rozmiaru
% Zdjecia zapisane w postaci zdj_[numer].jpg
numer = "3";        % numer zdj�cia
zdj_org = "zdj_org" + numer + ".jpg"        % stworzenie nazwy zdj orginal.
zdj = "zdj_" + numer                        % stworzenie nazwy zapisu
img = imread(zdj_org);                      % Wczytanie
info = imfinfo(zdj_org)                     % wy�wietlenie informacji
img = imrotate(img, -90);                   % obr�cenie zdj�cia
img_new = imcrop(img, [400 400 2200 3200]);     % Wyci�cie obszaru twarzy
imshowpair(img, img_new, 'montage');        % por�wnanie wyci�cia

% Je�li jest ok usu� znaki komentarza aby wygenerowa� zdj�cie 768x480 w
% r�nych formatach

% img_new = imresize(img_new, [768, 480]);
% imwrite(img_new, zdj + ".jpg");
% imwrite(img_new, zdj + ".bmp");
% imwrite(img_new, zdj + ".tiff");
