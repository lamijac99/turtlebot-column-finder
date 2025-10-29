function final_mask = conv_hull(image)
mask = image;
mask = bwareaopen(mask,1000); % provjeri 
imshow(mask);
%numWhitePixels = sum(slika2(:))
props = regionprops(mask, 'PixelList');
final_mask = mask;
for i = 1: length(props)
    k = convhull(props(i).PixelList(:,1),props(i).PixelList(:,2));
    BW = poly2mask(props(i).PixelList(k,1),props(i).PixelList(k,2),960,1280);
    final_mask = BW|final_mask;
    %imshow(final_mask);
end
end
