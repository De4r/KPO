% live detection
%% camera
clc; close all; clear all;
cam  = webcam(1)

%% live
faceDetector = vision.CascadeObjectDetector;
nose = vision.CascadeObjectDetector('ClassificationModel','Nose', 'UseROI', true);
nose.MergeThreshold = 50;
bothEyes = vision.CascadeObjectDetector('ClassificationModel','EyePairBig', 'UseROI', true);
bothEyes.MergeThreshold = 10;
lEyeCart = vision.CascadeObjectDetector('ClassificationModel','LeftEyeCART', 'UseROI', true);
lEyeCart.MergeThreshold = 15;
rEyeCart = vision.CascadeObjectDetector('ClassificationModel','RightEyeCART', 'UseROI', true);
rEyeCart.MergeThreshold = 15;
lEye = vision.CascadeObjectDetector('ClassificationModel','LeftEye', 'UseROI', true);
lEye.MergeThreshold = 10;
rEye = vision.CascadeObjectDetector('ClassificationModel','RightEye', 'UseROI', true);
rEye.MergeThreshold = 10;
%%
v = VideoWriter('test.avi');
open(v);
for i=1:45
    i = snapshot(cam); i=imresize(i, [600 800]);
    bbox = [];
    bbox = faceDetector(i);
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
    % Klasyfikacja wstêpna
%     lEyeCartbbox = [];
%     if ~isempty(bothEyesbbox)
%         lEyeCartbbox = lEyeCart(i, bothEyesbbox);
%         if ~isempty(lEyeCartbbox)
%             lEyeCartbbox=lEyeCartbbox(1, :);
%             i_f = insertObjectAnnotation(i_f, 'rectangle', lEyeCartbbox, 'LeftEyeCart');
%         end
%     end
%     rEyeCartbbox = [];
%     if ~isempty(bothEyesbbox)
%         rEyeCartbbox = rEyeCart(i, bothEyesbbox);
%         if ~isempty(rEyeCartbbox)
%             rEyeCartbbox=rEyeCartbbox(1, :);
%             i_f = insertObjectAnnotation(i_f, 'rectangle', rEyeCartbbox, 'RightEyeCart');
%         end
%     end

    % klasyfikacja dokladna, mniejszy klasyfikator, dodany region of intrest i
    % merge aby nie bylo kilka detekcj
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
        line([xr, xl], [yr, yl], 'Color','red');
    end
    if ~isempty(rEyebbox) && ~isempty(lEyebbox) && ~isempty(nosebbox)
        line([xn xn], [yn ys], 'Color','red'); hold off;
    end
    
    frame = getframe(gcf);
    writeVideo(v, frame);
end
close(v);