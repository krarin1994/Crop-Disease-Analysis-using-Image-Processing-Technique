    %Reading an image into an array
    [rgbImage, storedColorMap] = imread('binimg.jpg'); 
    [rows, columns, numberOfColorBands] = size(rgbImage);
    
    % Convert RGB image to HSV
	hsvImage = rgb2hsv(rgbImage);
    
	% Extract out the H, S, and V images individually
	hImage = hsvImage(:,:,1);
	sImage = hsvImage(:,:,2);
	vImage = hsvImage(:,:,3);
	[hueCounts, hueBinValues] = imhist(hImage); 
	maxHueBinValue = find(hueCounts > 0, 1, 'last'); 
	maxCountHue = max(hueCounts); 
	[saturationCounts, saturationBinValues] = imhist(sImage); 
	maxSaturationBinValue = find(saturationCounts > 0, 1, 'last'); 
	maxCountSaturation = max(saturationCounts); 
	[valueCounts, valueBinValues] = imhist(vImage); 
	maxValueBinValue = find(valueCounts > 0, 1, 'last'); 
	maxCountValue = max(valueCounts);
	maxCount = max([maxCountHue,  maxCountSaturation, maxCountValue]); 
	maxGrayLevel = max([maxHueBinValue, maxSaturationBinValue, maxValueBinValue]); % Just for our information....
	
    % Assign the low and high thresholds for each color band.
	hueThresholdLow = 0.1;
	hueThresholdHigh = 0.7;
	saturationThresholdLow = 0.2;
	saturationThresholdHigh = 1.0;
	valueThresholdLow = 0;
	valueThresholdHigh = 0.8;
   
    % Now apply each color band's particular thresholds to the color band
	hueMask = (hImage >= hueThresholdLow) & (hImage <= hueThresholdHigh);
	saturationMask = (sImage >= saturationThresholdLow) & (sImage <= saturationThresholdHigh);
	valueMask = (vImage >= valueThresholdLow) & (vImage <= valueThresholdHigh);
	coloredObjectsMask = hueMask & saturationMask & valueMask;
	
	% Take the largest blob only - it's the main leaf object.
	coloredObjectsMask = bwareafilt(coloredObjectsMask, 1);
	% Fill in any holes in the regions, since they are most likely red also.
	coloredObjectsMask = imfill(logical(coloredObjectsMask), 'holes');
	%subplot(2, 2, 1);
	%imshow(coloredObjectsMask, []);
	
    labeledImage = bwlabel(coloredObjectsMask);
	% Get all the blob properties.  Can only pass in originalImage in version R2008a and later.
	blobMeasurements = regionprops(labeledImage, 'Area', 'BoundingBox');   
	
    % Mask the image using bsxfun() function
	maskedRgbImage = bsxfun(@times, rgbImage, cast(coloredObjectsMask, 'like', rgbImage));
	% Make the masked (pure black) pixels white so they look like the original white background.
	maskedRgbImage(maskedRgbImage == 0) = 255;
	
    % Crop the image
	croppedImage = imcrop(maskedRgbImage, blobMeasurements.BoundingBox); % or rgbImage if you prefer the original background.
	% Show the cropped off RGB image.
	imshow(croppedImage);
    %save the cropped image to a folder
    imwrite(croppedImage, 'C:\Users\hp\Documents\MATLAB\Imageprocessing\clustbin.jpg','jpg');
         
    
   
    
    
    
    
