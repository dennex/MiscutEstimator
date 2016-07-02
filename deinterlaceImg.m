% this function deinterlaces the image
function [imEven, imOdd] = deinterlaceImg(img)

imEven = zeros(size(img,1),0);
imOdd = zeros(size(img,1),0);

for i = 1:size(img,2)
    if mod(i,2) == 0
        imEven = [imEven,img(:,i)];
    else
        imOdd = [imOdd,img(:,i)];
    end
end