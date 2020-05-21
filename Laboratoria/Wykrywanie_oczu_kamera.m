% Wykrywanie na ¿ywo
%% Kamera
clc; close all; clear all;
cam  = webcam(1)

%% Tworzenie detektorów cech charakterystycznych z modu³u vision
% Twarz
faceDetector = vision.CascadeObjectDetector;
% Nos, i podanie zakresu ³¹czenia wykryæ, region zainteresowania
nose = vision.CascadeObjectDetector('ClassificationModel','Nose', 'UseROI', true);
nose.MergeThreshold = 50;
% Oczy 2x i obszar ³¹czenia, region zainteresowania
bothEyes = vision.CascadeObjectDetector('ClassificationModel','EyePairBig', 'UseROI', true);
bothEyes.MergeThreshold = 10;
% Oczy lewe i prawe i ³¹czenie, region zainteresowania
lEyeCart = vision.CascadeObjectDetector('ClassificationModel','LeftEyeCART', 'UseROI', true);
lEyeCart.MergeThreshold = 15;
rEyeCart = vision.CascadeObjectDetector('ClassificationModel','RightEyeCART', 'UseROI', true);
rEyeCart.MergeThreshold = 15;
% Oczy mniejszy detektor, ³¹czenie
lEye = vision.CascadeObjectDetector('ClassificationModel','LeftEye', 'UseROI', true);
lEye.MergeThreshold = 10;
rEye = vision.CascadeObjectDetector('ClassificationModel','RightEye', 'UseROI', true);
rEye.MergeThreshold = 10;
%% Petla programu
% Zapis do pliku
v = VideoWriter('test.avi');
open(v);
for i=1:45
    i = snapshot(cam); i=imresize(i, [600 800]);    % pobór klatki z kamery
    bbox = [];
    bbox = faceDetector(i); % wykrecie twarzy
    i_f = i;
    bothEyesbbox = [];
    nosebbox = [];
    if ~isempty(bbox)
        i_f = insertObjectAnnotation(i_f, 'rectangle', bbox, 'Face');
        bbox=bbox(1, :);
        nosebbox = nose(i, bbox);
        bothEyesbbox = bothEyes(i, bbox); 
        i_f = insertObjectAnnotation(i_f, 'rectangle', bothEyesbbox, 'Eyes');
    end

    lEyebbox = [];
    if ~isempty(bothEyesbbox)
        lEyebbox = lEye(i, [bothEyesbbox(1)+bothEyesbbox(3)/2  bothEyesbbox(2) bothEyesbbox(3)/2 bothEyesbbox(4)]);
        
        if ~isempty(lEyebbox)
            i_f = insertObjectAnnotation(i_f, 'rectangle', lEyebbox, 'LeftEye');
            xl = lEyebbox(1) + lEyebbox(3)/2; yl = lEyebbox(2) + lEyebbox(4)/2;
        end
    end
    rEyebbox = [];
    if ~isempty(bothEyesbbox)
        rEyebbox = rEye(i, [bothEyesbbox(1) bothEyesbbox(2) bothEyesbbox(3)/2 bothEyesbbox(4)]);
        
        if ~isempty(rEyebbox)
            i_f = insertObjectAnnotation(i_f, 'rectangle', rEyebbox, 'RightEye');
            xr = rEyebbox(1) + rEyebbox(3)/2; yr = rEyebbox(2) + rEyebbox(4)/2;
        end
    end
    if ~isempty(nosebbox)
        i_f = insertObjectAnnotation(i_f, 'rectangle', nosebbox, 'Nose');
        xn = nosebbox(1) + nosebbox(3)/2; yn=nosebbox(2)+nosebbox(4)/2;
        
    end
    if ~isempty(rEyebbox) && ~isempty(lEyebbox)
        ys = (yr+yl)/2; xs = (xr+xl)/2;
        L = sqrt((xl-xr)^2+(yl-yr)^2);
        i_f = insertText(i_f, [xs, ys*0.85], ['L=' num2str(L)], 'AnchorPoint',"Center");
    end
    if ~isempty(rEyebbox) && ~isempty(lEyebbox) && ~isempty(nosebbox)
        L2 = sqrt((xs-xn)^2+(ys-yn)^2);
        i_f = insertText(i_f, [xn, yn*1.05], ['L=' num2str(L2)], 'AnchorPoint',"Center");
    end

    
    imshow(i_f); hold on;
    if ~isempty(rEyebbox) && ~isempty(lEyebbox)
        line([xr, xl], [yr, yl], 'Color', 'red', 'Marker', 'o');
    end
    if ~isempty(rEyebbox) && ~isempty(lEyebbox) && ~isempty(nosebbox)
        line([xn xn], [yn ys], 'Color','orange', 'Marker', 'o'); hold off;
    end
    
    frame = getframe(gcf);
    writeVideo(v, frame);
end
close(v);