clc;
clear;
close all;
more off;
Filename='Troizina 1827.jpg';
I=imread(Filename);

A=any_image_to_grayscale_func('Troizina 1827.jpg');
GammaValue=1; 
A=imadjust(A,[],[],GammaValue); 
Threshold= graythresh(A); 
BW = ~im2bw(A,Threshold);

% make morphological operations to clean the image ...
se = strel('rectangle',[3 9]);
img = imdilate(BW, se);

% get statistical information from connected components ...
labeled_img = bwlabel(img,8);
stats = regionprops(labeled_img, 'Area', 'Centroid', 'Perimeter');
areas = [stats.Area];
mean_area = mean(areas);
std_area = std(areas); %τυπική απόκλιση σ
outliers = areas(areas < mean_area - 2*std_area | areas > mean_area + 2*std_area);
Im=BW;
for i = 1:length(outliers)
    idx = find([stats.Area] == outliers(i));
    Im(labeled_img == idx)=0;
end


%left noise cleaning
se = strel('rectangle',[1 25]);
Image = imdilate(Im, se);
se = strel('rectangle',[48 10]);
Image = imerode(Image, se);

se = strel('rectangle',[1200 191]);
Image = imdilate(Image, se);

Noise=and(Im, Image);
Im=xor(Im,~Noise);
Im=~Im;

%top noise 
se = strel('rectangle',[1 44]);
Image = imerode(Im, se);
se = strel('rectangle',[215 780]);
Noise = imdilate(Image, se);

Im=and(Im, ~Noise);

%keep the text only, without noise
se = strel('rectangle',[1 5]);
text = imerode(Im, se);
se = strel('rectangle',[8 13]);
text = imdilate(text, se);
Im=and(Im,text);%final image


se = strel('rectangle',[3 18]);
Im = imdilate(Im, se);


%τόνοι
% se = strel('rectangle',[2 3]);
% Im = imopen(Im, se);
% se = strel('rectangle',[2 13]);
% Im = imdilate(Im, se);

[L,Count] = bwlabel(Im,8);

% --- Show each connected component with a different color
RGB = label2rgb(L,'lines');
figure('color','w');
image(RGB);
axis image;
set(gca,'xtick',[],'ytick',[]);
title(sprintf('There are %g connected components',Count));

R=[];
for i=1:Count
    [r,c]=find(L==i);
    XY=[c r];
    x1=min(XY(:,1));
    y1=min(XY(:,2));
    x2=max(XY(:,1));
    y2=max(XY(:,2));
    R=[R;x1 y1 x2 y2]; % append to R the bounding box as [x1 y1 x2 y2]
end

% show the original image with the final bounding boxes (Eikona 6)
ColorMap=lines;
figure('color','w');
A=(~BW)*255;
image(A); % NOTICE! the image is shown inverted
colormap(gray(256));
axis image;
set(gca,'xtick',[],'ytick',[]);
title('Bounding boxes');
for i=1:size(R,1)
    x1=R(i,1);
    y1=R(i,2);
    x2=R(i,3);
    y2=R(i,4);
    line([x1-0.5 x2+0.5 x2+0.5 x1-0.5 x1-0.5],[y1-0.5 y1-0.5 y2+0.5 y2+0.5 y1-0.5],'color',ColorMap(mod(i-1,7)+1,:),'linewidth',2);
end


if exist('R','var')
    dlmwrite('results.txt',R,'\t');
else
    error('Ooooops! There is no R variable!');
end