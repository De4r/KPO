%% Wczytanie zdjêcia w rozmiarze 768x480
clc; clear all; close all;
zdj = 'zdj_3.bmp'
i = imread(zdj);
info = imfinfo(zdj)
figure(1);
imagesc(i); title('Obraz orginalny');
% Zmierzone wartoœci
L_oczu = 62;    % [mm] odleg³oœæ Ÿrenic
L_nosa = 44;    % [mm] œrodek oczu - œrodek chrz¹stki nosa
L_ust = 46;     % [mm] d³ugoœæ ust bez k¹cików
L_policzki = 130;   % [mm] odleg³oœæ policzków
W_ust = 18;     % [mm] wysokoœæ ust

% Inicjalizacja obiektu rozpoznawania twarzy
faceDetector = vision.CascadeObjectDetector;
bbox = faceDetector(i);         % Wykrycie twarzy, zapisanie obszaru
% Dodanie annotacji obszaru twarzy
i_f = insertObjectAnnotation(i, 'rectangle', bbox, 'Face');

% Inicjalizacja detektora oczu, zwiêszkenie zakresu scalania wykryæ do 10
% Okreœlenie minimalnej wielkoœci obszaru oczu
bothEyes = vision.CascadeObjectDetector('ClassificationModel','EyePairBig');
bothEyes.MergeThreshold = 10; bothEyes.MinSize = [30 200];
% Inicjalizacja detektora nosa, zwiêszkenie zakresu scalania wykryæ do 20
% Okreœlenie minimalnej wielkoœci obszaru nosa
nose = vision.CascadeObjectDetector('ClassificationModel','Nose', 'UseROI', true);
nose.MergeThreshold = 20; nose.MinSize = [70 40];

% Wykrycie oczu, zapisanie obszaru, dodanie annotacji na zdj
bothEyesbbox = bothEyes(i);
i_f = insertObjectAnnotation(i_f, 'rectangle', bothEyesbbox, 'Eyes');

% Wykrycie nosa, zapisanie obszaru, dodanie annotacji na zdj
nosebbox = nose(i, bbox);
i_f = insertObjectAnnotation(i_f, 'rectangle', nosebbox, 'Nose');
% Zdjêcie z wykrytymi oczyma i nosem
figure(2);
imshow(i_f); 

% Klasyfikacja wstêpna pojedyñczych oczu
% Inicjalizacja detektorów, ograniczenie minimalnej wielkoœci, zakres
% scalania wyników
lEyeCart = vision.CascadeObjectDetector('ClassificationModel','LeftEyeCART');
lEyeCart.MergeThreshold = 15; lEyeCart.MinSize = [30 60];
rEyeCart = vision.CascadeObjectDetector('ClassificationModel','RightEyeCART');
rEyeCart.MergeThreshold = 15; rEyeCart.MinSize = [30 60];

% Wykrycie oczu, zapisanie obszarów, pos³u¿¹ jako ograniczony obszar dla
% dok³adniejszego detektora oczu
lEyeCartbbox = lEyeCart(i);
i_e = insertObjectAnnotation(i, 'rectangle', lEyeCartbbox, 'LeftEyeCart');
rEyeCartbbox = rEyeCart(i);
i_e = insertObjectAnnotation(i_e, 'rectangle', rEyeCartbbox, 'RightEyeCart');
% Zdjêcie z wykrytymi oczyma
figure(3);
imshow(i_e);

% Klasyfikacja dokladna, mniejszy klasyfikator, na podstawie regionu
% zaufania oraz scalanie wykryæ
lEye = vision.CascadeObjectDetector('ClassificationModel','LeftEye', 'UseROI', true);
lEye.MergeThreshold = 10;
rEye = vision.CascadeObjectDetector('ClassificationModel','RightEye', 'UseROI', true);
rEye.MergeThreshold = 10;


% Wykrywanie oczu w obszarach wczeœniej wyznaczonych zgrubnie
lEyebbox = lEye(i, lEyeCartbbox);
i_e2 = insertObjectAnnotation(i, 'rectangle', lEyebbox, 'LeftEye');
rEyebbox = rEye(i, rEyeCartbbox);
% Dodanie annotacji
i_e2 = insertObjectAnnotation(i_e2, 'rectangle', rEyebbox, 'RightEye');
i_e2 = insertObjectAnnotation(i_e2, 'rectangle', nosebbox, 'Nose');

% Obliczenie œrodka obszaru nosa
xn = nosebbox(1) + nosebbox(3)/2; yn=nosebbox(2)+nosebbox(4)/2;

% Srodki oczu
xl = lEyebbox(1) + lEyebbox(3)/2; yl = lEyebbox(2) + lEyebbox(4)/2;
xr = rEyebbox(1) + rEyebbox(3)/2; yr = rEyebbox(2) + rEyebbox(4)/2;
ys = (yr+yl)/2; xs = (xr+xl)/2;

% Obliczenie odleg³oœci w px. z Pitagorasa
L = sqrt((xl-xr)^2+(yl-yr)^2);
L2 = sqrt((xs-xn)^2+(ys-yn)^2);
% Wynzaczenie skali na podstawie odlegoœci oczu
skala = L_oczu / (xl-xr);
L_nosa_skala = L2*skala;


% Dodanie adnotacji
temp_str = "L oczu=" + num2str(L) + " px." + newline + "L rzecz=" + ...
    num2str(L_oczu) + " mm";
i_e2 = insertText(i_e2, [xs, ys*0.85], temp_str, 'AnchorPoint',"Center");

temp_str = "L nosa=" + num2str(L2) + " px." + newline + "L=" + ...
    num2str(L_nosa_skala) + " mm" + newline + ...
    "L recz=" + num2str(L_nosa) + " mm";
i_e2 = insertText(i_e2, [xn*1.35, yn*0.95], temp_str, 'AnchorPoint',"Center");

% Inicjalizacja detektora ust, zwiêszkenie zakresu scalania wykryæ
mouth = vision.CascadeObjectDetector('ClassificationModel','Mouth', 'UseROI', true);
mouth.MergeThreshold = 50;
% Wykrycie ust, zapisanie obszaru, dodanie annotacji na zdj
mouthbox = mouth(i, bbox);
i_e2 = insertObjectAnnotation(i_e2, 'rectangle', mouthbox, 'Mouth');

% Zdjêcie z odleg³oœciami
figure();
imshow(i_e2); hold on;
line([xr, xl], [yr, yl], 'Color', 'red', 'Marker','o');
line([xn xn], [yn ys], 'Color', 'red', 'Marker','o'); hold off;

