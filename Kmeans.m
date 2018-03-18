%Parts adapted from Kamal Kishor Sharma y10uc139 and
%https://uk.mathworks.com/help/images/examples/color-based-segmentation-using-k-means-clustering.html
he = imread('acne-face-27.jpg');
imshow(he), title('Acne Image');
lab_he = rgb2lab(he);

ab = lab_he(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);

nColors = 3;
% repeat the clustering 3 times to avoid local minima
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
    'Replicates',3);

pixel_labels = reshape(cluster_idx,nrows,ncols);
imshow(pixel_labels,[]), title('image labeled by cluster index');

segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);

for k = 1:nColors
    color = he;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end

%imshow(segmented_images{1}), title('objects in cluster 1');

imshow(segmented_images{3}), title('objects in cluster 3');
saveas(gcf, "fig1.png")
%imshow(segmented_images{3}), title('objects in cluster 3');

% mean_cluster_value = mean(cluster_center,2);
% [tmp, idx] = sort(mean_cluster_value);
% red_cluster_num = idx(3);
%
% L = lab_he(:,:,1);
% red_idx = find(pixel_labels == red_cluster_num);
% L_red = L(red_idx);
% is_light_red = imbinarize(rescale(L_red));
%
% acne_labels = repmat(uint8(0),[nrows ncols]);
% acne_labels(red_idx(is_light_red==false)) = 1;
% acne_labels = repmat(acne_labels,[1 1 3]);
% Acne = he;
% Acne(acne_labels ~= 1) = 0;
% imshow(blue_nuclei), title('Acne');
%
% Extract the individual red, green, and blue color channels.
he2 = imread('fig1.png');

red1Channel = he2(:, :, 1)>=160;
NotredChannel = he2(:, :, 1)<159;

%White
redChannel = he2(:, :, 1) == 255;
greenChannel = he2(:, :, 2) == 255;
blueChannel = he2(:, :, 3) == 255;
whitePixelImage = redChannel & greenChannel & blueChannel;
numwhitePixels = sum(whitePixelImage(:));


numRedPixels = sum(red1Channel(:));

numTruRed=numRedPixels- numwhitePixels;
numNotRed= sum(NotredChannel(:));
AcnePct= numTruRed/(numNotRed +numTruRed) * 100;

imshow(he2)
dim = [.16 .1 .3 .3];   %Label frame
        Label2 = annotation('textbox',dim, 'String',{'The Percentage coverage is', AcnePct, "%"},'FitBoxToText','on', 'Edgecolor','none', 'BackgroundColor','none', 'color','black');
        Label2.FontSize = 12;
        
message = sprintf('The number of pure red pixels = %d', numRedPixels);
message1 = sprintf('The percentage coverage = %d %%', AcnePct);
uiwait(helpdlg(message1));



