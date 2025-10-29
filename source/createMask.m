function [mask , maskedRGB] = createMask(RGB)
%
% Convert RGB image to chosen color space

ima = RGB;
%ima = imread('zelena_sjena.jpg');
image = im2double(ima);
%image =  imlocalbrighten(ima,0.8);

imR = squeeze(image(:,:,1));
imG = squeeze(image(:,:,2));
imB = squeeze(image(:,:,3));

%imshow(imB)

imBinR = imbinarize(imR, adaptthresh(imR,0.9));
imBinG = imbinarize(imG, adaptthresh(imG,0.9));
imBinB = imbinarize(imB, adaptthresh(imB,0.9)); %+0.03
%imshow(imBinB)
imBinary = imcomplement(imBinR&imBinG&imBinB);
%imshow(~imBinary)

imClean = imfill(imBinary, 'holes');
imClean = imclearborder(imClean);
imClean = imfill(imClean,26,'holes');

mask = imClean;

blobMeasurements = regionprops(mask, 'PixelList');

% k = convhull(blobMeasurements(2).PixelList(:,1),blobMeasurements(2).PixelList(:,2));
% 1 je bijela

% hold on
%  p = plot(blobMeasurements(2).PixelList(k,1),blobMeasurements(2).PixelList(k,2)) ;
%  p.LineWidth = 5;
% hold off
maskedRGB = RGB;
maskedRGB(repmat(~mask,[1 1 3])) = 0;

% BW = poly2mask(blobMeasurements(2).PixelList(k,1),blobMeasurements(2).PixelList(k,2),960,1280)
% mask = BW|mask;
imshow(mask)
% imshow(~BinaryHSV)

end