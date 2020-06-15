%% Wczytanie zdj�cia w rozmiarze 768x480
clc; clear all; close all;
zdj = 'zdj_3.bmp'
i = imread(zdj);
info = imfinfo(zdj)
figure(1);
imagesc(i); title('Obraz orginalny');
% Zmierzone warto�ci
L_oczu = 62;        % [mm] odleg�o�� �renic
L_nosa = 44;        % [mm] �rodek oczu - �rodek chrz�stki nosa
L_ust = 46;         % [mm] d�ugo�� ust bez k�cik�w
L_policzki = 130;   % [mm] odleg�o�� policzk�w
W_ust = 18;         % [mm] wysoko�� ust
% Podzia� na nnn+1 regionow
nnn = 6;
reg_ver = [1, size(i,1)*(1:1:nnn)/(nnn)];
reg_hor = [1, size(i,2)*(1:1:nnn)/(nnn)];

%% Wykrywanie ust
% Wykrycie ust z pomoc� r�nicy kana��w R-G
i_m = i(:,:,1)-i(:,:,2);
% histogram, pobranie liczby pixeli i odpowidajacym im kolorow
[cn, bn] = imhist(i_m);
% okreslenie maksimum histogramu
[max, idx] = max(cn(2:end));
% poziom jasno�ci o najwiekszej liczbie pixelow
bn(idx);
% Odj�cie do obrazu R-G warto�ci maksymalnego poziomu
i_m2 = imadd(i_m, -bn(idx));
% dostosowanie histogramu
i_m2 = imadjust(i_m2);

% Obraz po odj�ciu R-G
figure(10); sgtitle('R-G');
subplot(121)
imhist(i_m)
subplot(122)
imshow(i_m)

% Po odj�ciu od R-G warto�ci maksymalnego poziomu i poprawie histogramu
figure(11); sgtitle('R-G - max(hist)');
subplot(121)
imhist(i_m2)
subplot(122)
imshow(i_m2)

% binaryzacja z progiem 244 (naja�niejsze pixele to usta)
i_usta = imbinarize(i_m2, 244/255);
% Obszar poza dolnym regionem = 0
i_usta([reg_ver(1):reg_ver(length(reg_ver)-2)],:) = 0;
i_usta = bwmorph(i_usta, 'clean');  % Wyczyszczenie pojedy�czych pixeli
i_usta = bwmorph(i_usta, 'fill');   % Wype�nienie dziur
figure(12)
for o=1:4
    % Zamkni�cie z rosn�cym elementem strukturalnym
    i_usta = imclose(i_usta, strel('disk', o));
    imshowpair(i, i_usta, 'montage');
end
% po zamknieciu
imshowpair(i, i_usta, 'montage'); title('Usta po zamknieciu')

i_usta = imopen(i_usta, strel('disk', 2));  % Otwarcie
% po zamknieciu
figure(13)
imshowpair(i, i_usta, 'montage'); title('Ko�cowy region ust');
% Pobranie w�a�ciwo�ci regionu
usta_prop = regionprops(i_usta, 'all')

%% Wyszukanie oczu
i_oczyrgb = i;
i_oczygray = rgb2gray(i_oczyrgb);   % Skala szaro�ci
i_oczybw = imbinarize(i_oczygray, 33/255);  % Binaryzacja (czarne �renice)
i_oczybw = imcomplement(i_oczybw);  % Odwr�cenie obrazu binarnego
i_oczybw([reg_ver(1):reg_ver(3)],:,:) = 0;      % Zerowanie region�w
i_oczybw([reg_ver(4):reg_ver(end)],:,:) = 0;    % Zerowanie region�w
% Obrazy rgb, skala szaro�ci i po binaryzacji
figure(20); subplot(131); sgtitle('Szukanie �renic binaryzacj�');
imshow(i_oczyrgb)
subplot(132); imshow(i_oczygray);
subplot(133); imshow(i_oczybw);

% Operacje morfologiczne - czyszczenie pojedy�czych pixeli, wype�nianie
% otwtor�w (odbicie �wita�a aparatu w �renicach)
i_oczybw = bwmorph(i_oczybw, 'clean');
i_oczybw = bwmorph(i_oczybw, 'fill', 8);
i_oczybw = imfill(i_oczybw, 'holes');
% Otwarcie w celu pozybycia elemet�w nie bed�cych okr�gami
i_oczybw = imopen(i_oczybw, strel('disk', 3));
figure(21)
title('Znale�ione regiony �renic')
imshow(i_oczybw);
% Wyznaczenie w�a�ciwo�ci region�w
oczy_prop = regionprops(i_oczybw, 'all')

%% Wyszukanie nosa
i_nosrgb = i;
% Zerowanie region�w poza obszarem zainteresowania
i_nosrgb([reg_ver(1):reg_ver(3)],:,:) = 0;
i_nosrgb([reg_ver(5):reg_ver(end)],:,:) = 0;
i_nosrgb(:,[reg_hor(1):reg_hor(3)],:) = 0;
i_nosrgb(:,[reg_hor(5):reg_hor(end)],:) = 0;
i_nosgray = rgb2gray(i_nosrgb);     % Skala szaro�ci

% Binaryzacja (wyokrzystany refleks na nosie)
i_nosbw = imbinarize(i_nosgray, 194/255);

figure(30); sgtitle('Obszar wyszukiwania nosa');
subplot(131)
imshow(i_nosrgb);
subplot(132)
imshow(i_nosgray);
subplot(133)
imhist(i_nosgray)

% Operacje morfologiczne, czyszczenie i wype�nianie
i_nosbw = bwmorph(i_nosbw, 'clean');
i_nosbw = bwmorph(i_nosbw, 'fill');
% % Zamkni�cie i otwarcie elementem dyskowym
i_nosbw = imclose(i_nosbw, strel('disk', 3));
i_nosbw = imopen(i_nosbw, strel('disk', 2));
figure(32); title('Refleks �rodka chrz�stki nosa');
imshow(i_nosbw)
% Wyznaczenie w�a�ciwo�ci regionu
nos_prop = regionprops(i_nosbw, 'all')

%% Wyszukanie skrajni policzk�w
i_polrgb = i;
i_polgray = rgb2gray(i_polrgb);     % Skala szaro�ci

figure(40); title('Skala szaro�ci');
imshow(i_polgray);

figure(41); sgtitle('Binaryzacja na podstawie histogramu');
subplot(131);
imhist(i_polgray)

subplot(132);
i_polbw = imbinarize(i_polgray, 88/255);
imshow(i_polbw);

% Pe�na jasno�� w regionach innych ni� skajnych �rodkowych
i_polbw([reg_ver(1):reg_ver(4)],:,:) = 1;
i_polbw([reg_ver(5):reg_ver(end)],:,:) = 1;
i_polbw(:, [reg_hor(3):reg_hor(end-2)]) = 1;
i_polbw = imcomplement(i_polbw);        % Odwr�cenie obrazu binarnego

subplot(133);
imshow(i_polbw);

% Czyszczenie i wype�nianie luk
i_polbw = bwmorph(i_polbw, 'clean');
i_polbw = bwmorph(i_polbw, 'fill');
% Otwarcie elementem liniowym pionowym ( liniowo�� rys skarjni policzk�w) a
% nast�pnie dyskowym w celu wype�nienia i znowu elementem linowym
i_polbw = imopen(i_polbw, strel('line', 15, 90));
i_polbw = imopen(i_polbw, strel('disk', 2));
i_polbw = imopen(i_polbw, strel('line', 20, 90));

% Obszary policzk�w
figure(42)
imshowpair(i, i_polbw, 'montage'); title('Regniony skrajni policzk�w')
% Wyznaczenie w�a�ciwo�ci
pol_prop = regionprops(i_polbw, 'all')

%% Finalne z�o�enie wyznaczonych cech
i_f = i;

%%% Dodanie oznacze� oczu i obliczenie odleg�o�ci %%%
oko1_bbox = oczy_prop(1).BoundingBox;   % Prostok�t ograniczaj�cy
% Dodanie regionu z opisem
i_f= insertObjectAnnotation(i_f, 'rectangle', oko1_bbox, 'Oko prawe');
oko2_bbox = oczy_prop(2).BoundingBox;   % Prostok�t ograniczaj�cy
i_f= insertObjectAnnotation(i_f, 'rectangle', oko2_bbox, 'Oko lewe');

% Wsp�rz�dne �rodk�w �renic x, y, indeksy: l -lewe - r - prawe
oko_r = oczy_prop(1).Centroid;  % Parametr �rodka cie�ko�ci
oko_l = oczy_prop(2).Centroid;

% Wyznaczenie wsp�rz�dnych punktu pomi�dzy oczyma
ys = (oko_r(2)+oko_l(2))/2;
xs = (oko_r(1)+oko_l(1))/2;

% Wymiar skaluj�cy pozosta�e wymiary z px. -> mm.
skala = L_oczu/(oko_l(1)-oko_r(1));

% Obliczenie odleg�o�ci oczy, konstrukcja adnotacji i dodanie do obrazu
L_oczu_ = sqrt((oko_l(1)-oko_r(1))^2+(oko_l(2)-oko_r(2))^2);
temp_str = "Oczy" + newline + "L=" + num2str(L_oczu_) + ...
    "px." + newline + "L_rzecz=" + num2str(L_oczu) + "mm" + ...
    newline + "Skala=" + skala + "mm/px.";
i_f = insertText(i_f, [90, 105], temp_str, 'AnchorPoint', "Center");



%%% Dodanie oznaczenia ust i obliczenie wymiar�w %%%
usta_bbox = usta_prop.BoundingBox;  % Prostok�t ograniczaj�cy
% Wsp�rz�dne prawego i lewego ko�ca oraz �rodek wysoko�ci
uxr = usta_bbox(1); uxl = usta_bbox(1) + usta_bbox(3);
uy = usta_bbox(2)+usta_bbox(4)/2;

% Dodanie regionu, konstrukcja adnotacji i dodanie do zdj�cia
i_f= insertObjectAnnotation(i_f, 'rectangle', usta_bbox, 'Usta');
temp_str = "L=" + num2str(usta_bbox(3)) + "px." + newline + ...
    "L_skala=" + num2str(usta_bbox(3)*skala) + "mm" + newline + ...
    "L_rzecz=" + num2str(L_ust) + "mm" + newline + "W=" + ...
    num2str(usta_bbox(4)) + newline + "W_skala=" + ...
    num2str(usta_bbox(4)*skala)+ "mm" + newline + "W_rzecz=" + ...
    num2str(W_ust) + "mm";

i_f = insertText(i_f, [90, 150], temp_str);


%%% Dodanie oznaczenia policzk�w i obliczenie odleg�o�ci %%%
pol1_bbox = pol_prop(1).BoundingBox;    % Prostok�t ograniczaj�cy
i_f= insertObjectAnnotation(i_f, 'rectangle', pol1_bbox, 'Policzek');
pol2_bbox = pol_prop(2).BoundingBox;    % Prostok�t ograniczaj�cy
i_f= insertObjectAnnotation(i_f, 'rectangle', pol2_bbox, 'Policzek');

% Odleg�o�� skrajni policzk�w, wsp�rz�dne
pl = pol1_bbox(1);
pr = pol2_bbox(1)+pol2_bbox(3);
yp_sr = (pol_prop(1).Centroid(2) + pol_prop(2).Centroid(2) )/2;
L_pol = pr-pl;

temp_str = "L=" + num2str(L_pol) + "px." + newline + ...
    "L_skala=" + num2str(L_pol*skala) + "mm" + newline + ...
    "L_rzecz=" + num2str(L_policzki) + "mm";

i_f = insertText(i_f, [330, 80], temp_str);


%%% Dodanie regionu srodeka nosa i obliczenie odleg�o�ci %%%
nos_bbox = nos_prop.BoundingBox; % Prostok�t ograniczaj�cy
% Wsp�rz�dne �rodka
nx = nos_prop.Centroid(1);
ny = nos_prop.Centroid(2);
i_f= insertObjectAnnotation(i_f, 'rectangle', nos_bbox, 'Nos');
% dlugosc nosa �rodek chrz�stki do �rodka lini ��cz�cej oczy
L_nosa_ = sqrt( (nx - xs)^2 + (ny - ys)^2);

temp_str = "Nos" + newline + "L=" + num2str(L_nosa_) + ...
    "px." + newline + "L_skala=" + num2str(L_nosa_*skala) + ...
    "mm" + newline + "L_rzecz=" + num2str(L_nosa) + "mm";

i_f = insertText(i_f, [180, 75], temp_str);

% Obraz z naniesionymi wszystkimi oznaczeniami i odleg�o�ciami
figure(99);
imshow(i_f);
hold on;
line([oko_r(1), oko_l(1)], [oko_r(2), oko_l(2)], 'Color', 'red', 'Marker','.');
line([pl, pr], [yp_sr, yp_sr], 'Color', 'red', 'Marker','.');
line([nx, xs], [ny, ys], 'Color', 'red', 'Marker','.');
line([uxr, uxl], [uy, uy], 'Color', 'red', 'Marker','.');
line([(uxr+uxl)/2, (uxr+uxl)/2], [usta_bbox(2), ...
    usta_bbox(2)+usta_bbox(4)], 'Color', 'red', 'Marker','.');

% Binarny obraz wszystkich region�w
i_f2 = imadd(i_nosbw, i_usta);
i_f2 = im2bw(i_f2, 0.99);
i_f2 = imadd(i_f2, i_polbw);
i_f2 = im2bw(i_f2, 0.99);
i_f2 = imadd(i_f2, i_oczybw);

figure(100);
imshow(i_f2); title('Wszystkie wyznaczone regiony');
