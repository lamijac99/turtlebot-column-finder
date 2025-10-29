function [blobMeasurements, numberOfObjects] = shape_finder(img)
% img = imread('zelena2.png');
msk = img;

binaryImage = bwareaopen(msk,1500);

[labeledImage, numberOfObjects] = bwlabel(binaryImage);
blobMeasurements = regionprops(labeledImage,...
    'Perimeter', 'Area', 'FilledArea', 'Solidity', 'Centroid','PixelList','MaxFeretProperties');

% Get the outermost boundaries of the objects, just for fun, so we can highlight/outline the current blob in red.
filledImage = imfill(binaryImage, 'holes');
boundaries = bwboundaries(filledImage);

perimeters = [blobMeasurements.Perimeter];
areas = [blobMeasurements.Area];
filledAreas = [blobMeasurements.FilledArea];
solidities = [blobMeasurements.Solidity];

% Calculate circularities:
circularities = perimeters .^2 ./ (4 * pi * filledAreas);

% Print to command window.
for blobNumber = 1 : numberOfObjects
    % Outline the object so the user can see it.
    thisBoundary = boundaries{blobNumber};
    subplot(2, 2, 2); % Switch to upper right image.
    hold on;
    % Display prior boundaries in blue
    for k = 1 : blobNumber-1
        thisBoundary = boundaries{k};
        plot(thisBoundary(:,2), thisBoundary(:,1), 'b', 'LineWidth', 3);
    end
    % Display this boundary in red.
    thisBoundary = boundaries{blobNumber};
    plot(thisBoundary(:,2), thisBoundary(:,1), 'r', 'LineWidth', 3);
    subplot(2, 2, 4); % Switch to lower right image.

    % Determine the shape.
    if circularities(blobNumber) < 1.09
        % Theoretical value for a circle is 1.
        message = sprintf('For object #%d,\nthe perimeter = %.3f,\nthe area = %.3f,\nthe circularity = %.3f,\nso the object is a circle',...
            blobNumber, perimeters(blobNumber), areas(blobNumber), circularities(blobNumber));
        shape = 'circle';
        blobMeasurements(blobNumber).Shape = 'circle';
    elseif circularities(blobNumber) >= 1.1 && circularities(blobNumber) < 4
        % Theoretical value for a square is (4d)^2 / (4*pi*d^2) = 4/pi = 1.273
        message = sprintf('For object #%d,\nthe perimeter = %.3f,\nthe area = %.3f,\nthe circularity = %.3f,\nso the object is a square',...
            blobNumber, perimeters(blobNumber), areas(blobNumber), circularities(blobNumber));
        shape = 'square';
        blobMeasurements(blobNumber).Shape = 'square';
    else
        message = sprintf('The circularity of object #%d is %.3f,\nso the object is something else.',...
            blobNumber, circularities(blobNumber));
        shape = 'something else';
        blobMeasurements(blobNumber).Shape = 'others';
    end

    % Display the classification that we determined in overlay above the object.
    overlayMessage = sprintf('Object #%d = %s\ncirc = %.2f, s = %.2f', ...
        blobNumber, shape, circularities(blobNumber), solidities(blobNumber));
    text(blobMeasurements(blobNumber).Centroid(1), blobMeasurements(blobNumber).Centroid(2), ...
        overlayMessage, 'Color', 'r');

    % Ask the user if they want to continue
    if blobNumber < numberOfObjects
        button = questdlg(message, 'Continue', 'Continue', 'Cancel', 'Continue');
        if strcmp(button, 'Cancel')
            break;
        end
    end
end

end