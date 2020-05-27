%% Wczytanie zdjêcia w rozmiarze 768x480
clc; clear all; close all;
zdj = 'zdj_3.bmp'
i = imread(zdj);
info = imfinfo(zdj)
figure(1);
imagesc(i); title('Obraz orginalny');

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

% Wykrycie ust z pomoc¹ R-G
i_m = i(:,:,1)-i(:,:,2);
[cn, bn] = imhist(i_m);
[max, idx] = max(cn(2:end));
bn(idx)
i_m2 = imadd(i_m, -bn(idx));
i_m2 = imadjust(i_m2);

figure(4)
subplot(121)
imhist(i_m)
subplot(122)
imshow(i_m)

figure(5)
subplot(121)
imhist(i_m2)
subplot(122)
imshow(i_m2)


i_bw = imbinarize(i_m, 62/255);
i_bw2 = imbinarize(i_m2, 244/255);

figure(6)
imshowpair(i_bw, i_bw2, 'montage')

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

% Obliczenie odleg³oœci z Pitagorasa
L = sqrt((xl-xr)^2+(yl-yr)^2);
L2 = sqrt((xs-xn)^2+(ys-yn)^2);

% Dodanie annostacji
i_e2 = insertText(i_e2, [xs, ys*0.85], ['L oczu=' num2str(L)], 'AnchorPoint',"Center");
i_e2 = insertText(i_e2, [xn*1.35, yn*0.95], ['L nosa=' num2str(L2)], 'AnchorPoint',"Center");

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

