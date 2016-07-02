% this script loads in a file, asks for clicked position, detects the root
% close to the clicked point


clear all
% im = imread('skewed.jpg');
% im = imread('brownColor.jpg');

% im = rgb2hsv(imread('PNGnormal.jpg'));
im2 = imread('largechamfer.jpg');
% im2 = imread('richmond.jpg');
% im2 = imread('grayat.jpg');
% im2 = imread('black.jpg');
% im2 = imread('grayscale.jpg');
im(:,:,1) = im2;
im(:,:,2) = im2;
im(:,:,3) = im2;
% im = imread('PNGnormal.jpg');
% im = imread('purple.jpg');
imshow(im);
% % HSV distance
% xref = 0.545*cos(0.0833*2*pi);
% yref = 0.545*sin(0.0833*2*pi);
% zref = 0.173;
% imDist = sqrt((im(:,:,2).*cos(im(:,:,1)*2*pi) - xref).^2 + ...
%     (im(:,:,2).*sin(im(:,:,1)*2*pi) - yref).^2 + ...
%     (im(:,:,3) - zref).^2);
% % im = im(:,:,3); % use the V channel only
% imshow(imDist);

% click on the gap
[x,y] = ginput(1)
x = int32(x);
y = int32(y);

% stats around the clicked area
AOI = im((y-5):(y+5),(x-10):(x+10),1);
AOI2 = im((y-5):(y+5),(x-10):(x+10),2);
AOI3 = im((y-5):(y+5),(x-10):(x+10),3);
stdevA = sqrt((std(double(reshape(AOI,size(AOI,1)*size(AOI,2),1))))^2 + ...
    (std(double(reshape(AOI2,size(AOI2,1)*size(AOI2,2),1))))^2 + ...
    (std(double(reshape(AOI3,size(AOI3,1)*size(AOI3,2),1))))^2)

% magic wand assumes a color image
im = imfilter(im,ones(7,7)/49);
prevLeft = x;
prevRight = x;
prevTop = y;
prevBottom = y;
left = x;
right = x;
top = y;
bottom = y;
foundL = 0;
foundR = 0;
foundT = 0;
foundB = 0;

% for i = 1:1:20
i = 1;
% while ((foundL == 0 || foundR == 0 || foundT == 0 || foundB == 0 )&& i < 30)
while ((foundL == 0 || foundR == 0) && i < 30)
    % bin_mask = magicwand(im,y,x,stdevA);
    bin_mask = magicwand(im,y-i+1:y+i-1,x-i+1:x+i-1,i);
    imshow(bin_mask)
    sumIm = sum(bin_mask);
    sumVertIm = sum(bin_mask');
    leftGap = min(find(sumIm ~=0));
    rightGap = max(find(sumIm ~= 0));
    topGap = min(find(sumVertIm ~=0));
    bottomGap = max(find(sumVertIm ~= 0));

    imFin(:,:,1) = im(:,:,1);
    imFin(:,:,3) = im(:,:,2);
    imFin(:,:,2) = bin_mask * 255;
    imshow(imFin);
    
    leftChange = prevLeft - leftGap;
    rightChange = prevRight - rightGap;
    topChange = prevTop - topGap;
    bottomChange = prevBottom - bottomGap;
    
    
    
% %     disp(strcat(int2str(leftChange),' <--> ',int2str(rightChange)));
    if abs(leftChange) > 100 && foundL == 0
        % found the left
        left = prevLeft
        foundL = 1;
    else
        prevLeft = leftGap;
    end
    
    if abs(rightChange) > 100 && foundR == 0
        % found the right
        right = prevright
        foundR = 1;
    else
        prevright = rightGap;
    end
    
    if abs(topChange) > 40 && foundT == 0
        % found the top
        top = prevtop
        foundT = 1;
    else
        prevtop = topGap;
    end
    
    if abs(bottomChange) > 40 && foundB == 0
        % found the bottom
        bottom = prevBottom
        foundB = 1;
    else
        prevbottom = bottomGap;
    end

%     pause
     i = i+1;
end
% get information on particle
rectangle('Position',[left,top,right-left,bottom-top],'FaceColor','r')

% pause
% % find root in the close vicinity (absolute value, along line of y clicked)
% temp = imDist(y-10:y+10,x-50:x+50);
% gradFilt = [1 1 1 1 1 1 0 -1 -1 -1 -1 -1 -1;2 2 2 2 2 2 0 -2 -2 -2 -2 -2 -2;1 1 1 1 1 1 0 -1 -1 -1 -1 -1 -1];
% gradTemp = filter2(gradFilt,temp,'valid');  
% subplot(2,1,1);
% imagesc(temp);
% subplot(2,1,2);
% imagesc(gradTemp);
% pause
% CM1 = cornermetric(temp, 'FilterCoefficients',fspecial('gaussian',[1 21],2));
% C_adjusted = imadjust(CM1);
% %imshow(C_adjusted)
% subplot(2,1,1);
% imagesc(temp);
% subplot(2,1,2);
% imagesc(CM1);
% % show most likely position on image