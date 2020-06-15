%% Wczytanie zdjêcia w rozmiarze 768x480
clc; clear all; close all;
zdj = 'zdj_3.bmp'
i = imread(zdj);
info = imfinfo(zdj)
figure(1);
imagesc(i); title('Obraz orginalny');
% Zmierzone wartoœci
L_oczu = 62;        % [mm] odleg³oœæ Ÿrenic
L_nosa = 44;        % [mm] œrodek oczu - œrodek chrz¹stki nosa
L_ust = 46;         % [mm] d³ugoœæ ust bez k¹cików
L_policzki = 130;   % [mm] odleg³oœæ policzków
W_ust = 18;         % [mm] wysokoœæ ust
% Podzia³ na nnn+1 regionow
nnn = 6;
reg_ver = [1, size(i,1)*(1:1:nnn)/(nnn)];
reg_hor = [1, size(i,2)*(1:1:nnn)/(nnn)];

%% Wykrywanie ust
% Wykrycie ust z pomoc¹ ró¿nicy kana³ów R-G
i_m = i(:,:,1)-i(:,:,2);
% histogram, pobranie liczby pixeli i odpowidajacym im kolorow
[cn, bn] = imhist(i_m);
% okreslenie maksimum histogramu
[max, idx] = max(cn(2:end));
% poziom jasnoœci o najwiekszej liczbie pixelow
bn(idx);
% Odjêcie do obrazu R-G wartoœci maksymalnego poziomu
i_m2 = imadd(i_m, -bn(idx));
% dostosowanie histogramu
i_m2 = imadjust(i_m2);

% Obraz po odjêciu R-G
figure(10); sgtitle('R-G');
subplot(121)
imhist(i_m)
subplot(122)
imshow(i_m)

% Po odjêciu od R-G wartoœci maksymalnego poziomu i poprawie histogramu
figure(11); sgtitle('R-G - max(hist)');
subplot(121)
imhist(i_m2)
subplot(122)
imshow(i_m2)

% binaryzacja z progiem 244 (najaœniejsze pixele to usta)
i_usta = imbinarize(i_m2, 244/255);
% Obszar poza dolnym regionem = 0
i_usta([reg_ver(1):reg_ver(length(reg_ver)-2)],:) = 0;
i_usta = bwmorph(i_usta, 'clean');  % Wyczyszczenie pojedyñczych pixeli
i_usta = bwmorph(i_usta, 'fill');   % Wype³nienie dziur
figure(12)
for o=1:4
    % Zamkniêcie z rosn¹cym elementem strukturalnym
    i_usta = imclose(i_usta, strel('disk', o));
    imshowpair(i, i_usta, 'montage');
end
% po zamknieciu
imshowpair(i, i_usta, 'montage'); title('Usta po zamknieciu')

i_usta = imopen(i_usta, strel('disk', 2));  % Otwarcie
% po zamknieciu
figure(13)
imshowpair(i, i_usta, 'montage'); title('Koñcowy region ust');
% Pobranie w³aœciwoœci regionu
usta_prop = regionprops(i_usta, 'all')

%% Wyszukanie oczu
i_oczyrgb = i;
i_oczygray = rgb2gray(i_oczyrgb);   % Skala szaroœci
i_oczybw = imbinarize(i_oczygray, 33/255);  % Binaryzacja (czarne Ÿrenice)
i_oczybw = imcomplement(i_oczybw);  % Odwrócenie obrazu binarnego
i_oczybw([reg_ver(1):reg_ver(3)],:,:) = 0;      % Zerowanie regionów
i_oczybw([reg_ver(4):reg_ver(end)],:,:) = 0;    % Zerowanie regionów
% Obrazy rgb, skala szaroœci i po binaryzacji
figure(20); subplot(131); sgtitle('Szukanie Ÿrenic binaryzacj¹');
imshow(i_oczyrgb)
subplot(132); imshow(i_oczygray);
subplot(133); imshow(i_oczybw);

% Operacje morfologiczne - czyszczenie pojedyñczych pixeli, wype³nianie
% otwtorów (odbicie œwita³a aparatu w Ÿrenicach)
i_oczybw = bwmorph(i_oczybw, 'clean');
i_oczybw = bwmorph(i_oczybw, 'fill', 8);
i_oczybw = imfill(i_oczybw, 'holes');
% Otwarcie w celu pozybycia elemetów nie bed¹cych okrêgami
i_oczybw = imopen(i_oczybw, strel('disk', 3));
figure(21)
title('ZnaleŸione regiony Ÿrenic')
imshow(i_oczybw);
% Wyznaczenie w³aœciwoœci regionów
oczy_prop = regionprops(i_oczybw, 'all')

%% Wyszukanie nosa
i_nosrgb = i;
% Zerowanie regionów poza obszarem zainteresowania
i_nosrgb([reg_ver(1):reg_ver(3)],:,:) = 0;
i_nosrgb([reg_ver(5):reg_ver(end)],:,:) = 0;
i_nosrgb(:,[reg_hor(1):reg_hor(3)],:) = 0;
i_nosrgb(:,[reg_hor(5):reg_hor(end)],:) = 0;
i_nosgray = rgb2gray(i_nosrgb);     % Skala szaroœci

% Binaryzacja (wyokrzystany refleks na nosie)
i_nosbw = imbinarize(i_nosgray, 194/255);

figure(30); sgtitle('Obszar wyszukiwania nosa');
subplot(131)
imshow(i_nosrgb);
subplot(132)
imshow(i_nosgray);
subplot(133)
imhist(i_nosgray)

% Operacje morfologiczne, czyszczenie i wype³nianie
i_nosbw = bwmorph(i_nosbw, 'clean');
i_nosbw = bwmorph(i_nosbw, 'fill');
% % Zamkniêcie i otwarcie elementem dyskowym
i_nosbw = imclose(i_nosbw, strel('disk', 3));
i_nosbw = imopen(i_nosbw, strel('disk', 2));
figure(32); title('Refleks œrodka chrz¹stki nosa');
imshow(i_nosbw)
% Wyznaczenie w³aœciwoœci regionu
nos_prop = regionprops(i_nosbw, 'all')

%% Wyszukanie skrajni policzków
i_polrgb = i;
i_polgray = rgb2gray(i_polrgb);     % Skala szaroœci

figure(40); title('Skala szaroœci');
imshow(i_polgray);

figure(41); sgtitle('Binaryzacja na podstawie histogramu');
subplot(131);
imhist(i_polgray)

subplot(132);
i_polbw = imbinarize(i_polgray, 88/255);
imshow(i_polbw);

% Pe³na jasnoœæ w regionach innych ni¿ skajnych œrodkowych
i_polbw([reg_ver(1):reg_ver(4)],:,:) = 1;
i_polbw([reg_ver(5):reg_ver(end)],:,:) = 1;
i_polbw(:, [reg_hor(3):reg_hor(end-2)]) = 1;
i_polbw = imcomplement(i_polbw);        % Odwrócenie obrazu binarnego

subplot(133);
imshow(i_polbw);

% Czyszczenie i wype³nianie luk
i_polbw = bwmorph(i_polbw, 'clean');
i_polbw = bwmorph(i_polbw, 'fill');
% Otwarcie elementem liniowym pionowym ( liniowoœæ rys skarjni policzków) a
% nastêpnie dyskowym w celu wype³nienia i znowu elementem linowym
i_polbw = imopen(i_polbw, strel('line', 15, 90));
i_polbw = imopen(i_polbw, strel('disk', 2));
i_polbw = imopen(i_polbw, strel('line', 20, 90));

% Obszary policzków
figure(42)
imshowpair(i, i_polbw, 'montage'); title('Regniony skrajni policzków')
% Wyznaczenie w³aœciwoœci
pol_prop = regionprops(i_polbw, 'all')

%% Finalne z³o¿enie wyznaczonych cech
i_f = i;

%%% Dodanie oznaczeñ oczu i obliczenie odleg³oœci %%%
oko1_bbox = oczy_prop(1).BoundingBox;   % Prostok¹t ograniczaj¹cy
% Dodanie regionu z opisem
i_f= insertObjectAnnotation(i_f, 'rectangle', oko1_bbox, 'Oko prawe');
oko2_bbox = oczy_prop(2).BoundingBox;   % Prostok¹t ograniczaj¹cy
i_f= insertObjectAnnotation(i_f, 'rectangle', oko2_bbox, 'Oko lewe');

% Wspó³rzêdne œrodków Ÿrenic x, y, indeksy: l -lewe - r - prawe
oko_r = oczy_prop(1).Centroid;  % Parametr œrodka cie¿koœci
oko_l = oczy_prop(2).Centroid;

% Wyznaczenie wspó³rzêdnych punktu pomiêdzy oczyma
ys = (oko_r(2)+oko_l(2))/2;
xs = (oko_r(1)+oko_l(1))/2;

% Wymiar skaluj¹cy pozosta³e wymiary z px. -> mm.
skala = L_oczu/(oko_l(1)-oko_r(1));

% Obliczenie odleg³oœci oczy, konstrukcja adnotacji i dodanie do obrazu
L_oczu_ = sqrt((oko_l(1)-oko_r(1))^2+(oko_l(2)-oko_r(2))^2);
temp_str = "Oczy" + newline + "L=" + num2str(L_oczu_) + ...
    "px." + newline + "L_rzecz=" + num2str(L_oczu) + "mm" + ...
    newline + "Skala=" + skala + "mm/px.";
i_f = insertText(i_f, [90, 105], temp_str, 'AnchorPoint', "Center");



%%% Dodanie oznaczenia ust i obliczenie wymiarów %%%
usta_bbox = usta_prop.BoundingBox;  % Prostok¹t ograniczaj¹cy
% Wspó³rzêdne prawego i lewego koñca oraz œrodek wysokoœci
uxr = usta_bbox(1); uxl = usta_bbox(1) + usta_bbox(3);
uy = usta_bbox(2)+usta_bbox(4)/2;

% Dodanie regionu, konstrukcja adnotacji i dodanie do zdjêcia
i_f= insertObjectAnnotation(i_f, 'rectangle', usta_bbox, 'Usta');
temp_str = "L=" + num2str(usta_bbox(3)) + "px." + newline + ...
    "L_skala=" + num2str(usta_bbox(3)*skala) + "mm" + newline + ...
    "L_rzecz=" + num2str(L_ust) + "mm" + newline + "W=" + ...
    num2str(usta_bbox(4)) + newline + "W_skala=" + ...
    num2str(usta_bbox(4)*skala)+ "mm" + newline + "W_rzecz=" + ...
    num2str(W_ust) + "mm";

i_f = insertText(i_f, [90, 150], temp_str);


%%% Dodanie oznaczenia policzków i obliczenie odleg³oœci %%%
pol1_bbox = pol_prop(1).BoundingBox;    % Prostok¹t ograniczaj¹cy
i_f= insertObjectAnnotation(i_f, 'rectangle', pol1_bbox, 'Policzek');
pol2_bbox = pol_prop(2).BoundingBox;    % Prostok¹t ograniczaj¹cy
i_f= insertObjectAnnotation(i_f, 'rectangle', pol2_bbox, 'Policzek');

% Odleg³oœæ skrajni policzków, wspó³rzêdne
pl = pol1_bbox(1);
pr = pol2_bbox(1)+pol2_bbox(3);
yp_sr = (pol_prop(1).Centroid(2) + pol_prop(2).Centroid(2) )/2;
L_pol = pr-pl;

temp_str = "L=" + num2str(L_pol) + "px." + newline + ...
    "L_skala=" + num2str(L_pol*skala) + "mm" + newline + ...
    "L_rzecz=" + num2str(L_policzki) + "mm";

i_f = insertText(i_f, [330, 80], temp_str);


%%% Dodanie regionu srodeka nosa i obliczenie odleg³oœci %%%
nos_bbox = nos_prop.BoundingBox; % Prostok¹t ograniczaj¹cy
% Wspó³rzêdne œrodka
nx = nos_prop.Centroid(1);
ny = nos_prop.Centroid(2);
i_f= insertObjectAnnotation(i_f, 'rectangle', nos_bbox, 'Nos');
% dlugosc nosa œrodek chrz¹stki do œrodka lini ³¹cz¹cej oczy
L_nosa_ = sqrt( (nx - xs)^2 + (ny - ys)^2);

temp_str = "Nos" + newline + "L=" + num2str(L_nosa_) + ...
    "px." + newline + "L_skala=" + num2str(L_nosa_*skala) + ...
    "mm" + newline + "L_rzecz=" + num2str(L_nosa) + "mm";

i_f = insertText(i_f, [180, 75], temp_str);

% Obraz z naniesionymi wszystkimi oznaczeniami i odleg³oœciami
figure(99);
imshow(i_f);
hold on;
line([oko_r(1), oko_l(1)], [oko_r(2), oko_l(2)], 'Color', 'red', 'Marker','.');
line([pl, pr], [yp_sr, yp_sr], 'Color', 'red', 'Marker','.');
line([nx, xs], [ny, ys], 'Color', 'red', 'Marker','.');
line([uxr, uxl], [uy, uy], 'Color', 'red', 'Marker','.');
line([(uxr+uxl)/2, (uxr+uxl)/2], [usta_bbox(2), ...
    usta_bbox(2)+usta_bbox(4)], 'Color', 'red', 'Marker','.');

% Binarny obraz wszystkich regionów
i_f2 = imadd(i_nosbw, i_usta);
i_f2 = im2bw(i_f2, 0.99);
i_f2 = imadd(i_f2, i_polbw);
i_f2 = im2bw(i_f2, 0.99);
i_f2 = imadd(i_f2, i_oczybw);

figure(100);
imshow(i_f2); title('Wszystkie wyznaczone regiony');
