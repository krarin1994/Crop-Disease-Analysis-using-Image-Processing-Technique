rgb=imread('clustbin.jpg');
% Get the dimensions of the image.  
% numberOfColorChannels should be = 1 for a gray scale image, and 3 for an RGB color image.
[rows, columns, numberOfColorChannels] = size(rgb);
if numberOfColorChannels > 1
	grayImage = rgb2gray(rgb); 
end

% Display the image.
figure,imshow(grayImage, []);

% Binarize the image
binaryImage = grayImage < 128;
figure,imshow(binaryImage);
% Fill holes.
%binaryImage = imfill(binaryImage, 'holes');
figure(1),imshow(binaryImage);
% Get the leaf area
leafArea = sum(binaryImage(:))

% Display the image.
imshow(binaryImage, []);

%Display area of leaf
disp(leafArea);
