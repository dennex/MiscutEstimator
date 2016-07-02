function [left, right] = FindLeftRight(img)

theSum = sum(img,1);

threshold = Percentile(theSum, 0.9);

binarySum = theSum > threshold*0.5;

medianSum = medfilt2(binarySum,[1 5]);

left = 1;
found = 0;
i = 1;
while (found == 0 && i<length(medianSum))
    if (medianSum(i) >0)
        found = 1;
        left = i;
    end
    i = i+1;
end

right = length(medianSum);
found = 0;
i = length(medianSum);
while (found == 0 && i>0)
    if (medianSum(i) > 0)
        found = 1;
        right = i;
    end
    i = i-1;
end
