fabric = imread('001bin.jpg');%reading the cropped rgb image
figure(1), imshow(fabric), title('fabric');

load regioncoordinates;
nColors = 6;
sample_regions = false([size(fabric,1) size(fabric,2) nColors]);
for count = 1:nColors
  sample_regions(:,:,count) = roipoly(fabric,region_coordinates(:,1,count),...
                                      region_coordinates(:,2,count));
end
%imshow(sample_regions(:,:,2)),title('sample region for red');

lab_fabric = rgb2lab(fabric);
a = lab_fabric(:,:,2);
b = lab_fabric(:,:,3);
color_markers = zeros([nColors, 2]);
for count = 1:nColors
  color_markers(count,1) = mean2(a(sample_regions(:,:,count)));
  color_markers(count,2) = mean2(b(sample_regions(:,:,count)));
end


color_labels = 0:nColors-1;
a = double(a);
b = double(b);
distance = zeros([size(a), nColors]);
for count = 1:nColors
  distance(:,:,count) = ( (a - color_markers(count,1)).^2 + ...
                      (b - color_markers(count,2)).^2 ).^0.5;
end
[~, label] = min(distance,[],3);
label = color_labels(label);
clear distance;

rgb_label = repmat(label,[1 1 3]);
segmented_images = zeros([size(fabric), nColors],'uint8');

for count = 1:nColors
  color = fabric;
  color(rgb_label ~= color_labels(count)) = 0;
  segmented_images(:,:,:,count) = color;
end 

%imshow(segmented_images(:,:,:,2)), title('red objects');

%imshow(segmented_images(:,:,:,3)), title('green objects');

%imshow(segmented_images(:,:,:,4)), title('purple objects');

%imshow(segmented_images(:,:,:,5)), title('magenta objects');
figure,
imshow(segmented_images(:,:,:,6)), title('yellow objects');
imgseg=segmented_images(:,:,:,6);
imwrite(imgseg, 'C:\Users\hp\Documents\MATLAB\Imageprocessing\cluster.jpg','jpg');
level = graythresh(imgseg);
bwb=im2bw(imgseg,level);
figure,
imshow(bwb);
yellowArea = sum(bwb(:));
disp(yellowArea);


