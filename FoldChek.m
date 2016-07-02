close all;
clear all;
% load image
im = imread('testFCimg.jpg','jpg');
im = im(:,:,1);

% deinterlace
[imEven,imOdd] = deinterlaceImg(im);
subplot(121);imshow(imOdd);
subplot(122);imshow(imEven);
figure; imshow(imEven);
[x,y] = ginput(2);


% crop
center = size(imEven,1)/2;
top = center - 40;
bottom = center + 40;

% even is top, odd is bottom
imEven = imEven(top:bottom,:);
imOdd = imOdd(top:bottom,:);
subplot(121);imshow(imOdd);
subplot(122);imshow(imEven);

% find left right
[left,right] = FindLeftRight(imEven);
right = 168;
edgesImg = edge(imEven, 'sobel');
% find top edges
[topStrengths, topEdges] = min(edgesImg,[],1);
[botStrengths, botEdges] = max(edgesImg, [],1);

% make gap line
gapHeights = botEdges - topEdges;

% delete points between clicked points and out of the box
gapHeights(1:left) = -1;
gapHeights(x(1):x(2)) = -1;
gapHeights(right:length(gapHeights)) = -1;
plot(1:length(gapHeights),gapHeights);

% x,y trimmed
gapImage = zeros(max(gapHeights+10), length(gapHeights));
gapImageLeft = zeros(max(gapHeights+10), length(gapHeights));
for i = 1:x(1)
    if gapHeights(i)>0
        gapImageLeft(gapHeights(i),i)=1;
        gapImage(gapHeights(i),i)=1;
    end
end

% x,y trimmed
gapImageRight = zeros(max(gapHeights+10), length(gapHeights));
for i = int32(x(2)):right
    if gapHeights(i)>0
        gapImageRight(gapHeights(i),i)=1;
        gapImage(gapHeights(i),i)=1;
    end
end


% using hough transform left
[Hleft,Tleft,Rleft] = hough(gapImageLeft);

% P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
Pleft = houghpeaks(Hleft,1);

figure; imshow(gapImage);hold

lines = houghlines(gapImageLeft,Tleft,Rleft,Pleft,'FillGap',5,'MinLength',7);
% figure, imshow(gapImageLeft), hold on
% calculate standard deviation on linear regression
% rho=xcos(theta) + ysin(theta)
rhoLeft = lines.rho;
thetaLeft = lines.theta/180*pi;
pt1 = [1 (rhoLeft - cos(thetaLeft))/sin(thetaLeft) ];
pt2 = [size(gapImageLeft,2) (rhoLeft - size(gapImageLeft,2)*cos(thetaLeft))/sin(thetaLeft)];
plot([pt1(1) pt2(1)], [pt1(2) pt2(2)]+1)

% using hough transform right
[Hright,Tright,Rright] = hough(gapImageRight);

% P  = houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
Pright = houghpeaks(Hright,1);

lines = houghlines(gapImageRight,Tright,Rright,Pright,'FillGap',5,'MinLength',7);
% figure, imshow(gapImageRight), hold on
% calculate standard deviation on linear regression
% rho=xcos(theta) + ysin(theta)
rhoRight = lines.rho;
thetaRight = lines.theta/180*pi;
pt1 = [1 (rhoRight - cos(thetaRight))/sin(thetaRight) ];
pt2 = [size(gapImageRight,2) (rhoRight - size(gapImageRight,2)*cos(thetaRight))/sin(thetaRight)];
plot([pt1(1) pt2(1)], [pt1(2) pt2(2)]+1)