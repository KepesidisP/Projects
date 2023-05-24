clc;
clear;
close all;
more off;

% ------------------------------------------------------
% PART B EVALUATION
% ------------------------------------------------------
% --- INIT
if exist('OCTAVE_VERSION', 'builtin')>0
    % If in OCTAVE load the image package
    warning off;
    pkg load image;
    warning on;
end
% ------------------------------------------------------
% COMPARE RESULTS TO GROUND TRUTH
% ------------------------------------------------------
% --- Step B1
% load the ground truth
GT=dlmread('Troizina 1827_ground_truth.txt');
% load our results (if available)
if exist('results.txt','file')
    R=dlmread('results.txt');
else
    error('Ooooops! There is no results.txt file!');
end

I=any_image_to_grayscale_func('Troizina 1827.jpg');
figure('units','normalized','position',[0.1 0.1 0.8 0.8]);
image(I);
colormap(gray(256));
axis image off;
hold on;

Ng=size(GT,1);
x1=GT(:,1);
y1=GT(:,2);
x2=GT(:,3);
y2=GT(:,4);
patch([x1 x1 x2 x2 x1]',[y1 y2 y2 y1 y1]',ones(5,size(GT,1)),'facecolor','y','facealpha',0.3);
text(x1,y1,char(num2str(((1:Ng)'))),'color',[0.9 0.5 0.2],'verticalalignment','bottom','fontsize',16);

Nd=size(R,1);
x1=R(:,1);
y1=R(:,2);
x2=R(:,3);
y2=R(:,4);
patch([x1 x1 x2 x2 x1]',[y1 y2 y2 y1 y1]',ones(5,size(R,1)),'facecolor','b','facealpha',0.3);
text(x1,y1,char(num2str(((1:Nd)'))),'color',[0.0 0.1 0.8],'verticalalignment','bottom','fontsize',16);

% --- Step B2
% define the threshold for the IOU matrix
T=0.7; % or 0.3 or 0.7

% calculate IOU for all the results
xmin=R(:,1);
ymin=R(:,2);
xmax=R(:,3);
ymax=R(:,4);
gtxmin=GT(:,1);
gtymin=GT(:,2);
gtxmax=GT(:,3);
gtymax=GT(:,4);

RArea=(xmax-xmin+1).*(ymax-ymin+1);
GTArea=(gtxmax-gtxmin+1).*(gtymax-gtymin+1);
Intersect=rectint([xmin ymin (xmax-xmin+1) (ymax-ymin+1)],[gtxmin gtymin (gtxmax-gtxmin+1) (gtymax-gtymin+1)]);
Union=bsxfun(@plus,RArea,GTArea')-Intersect;

f=Intersect./Union;
IOU=f;

% apply the IOU threshold
IOUFinal=IOU>=T;

dlmwrite('IOU.txt',IOU,'delimiter','\t','precision',2);
% calculate TP, FP, FN, Recall, Precision and F-Measure
[y,x]=size(IOUFinal);
tp=0;
%clalculate tp fn
for i=1:x %87 stiles
    for j=1:y %159 grammes
        if IOUFinal(j,i)==1
            tp=tp+1;
            break;
        end
    end
end
fn=x-tp;

%calculate tn fp
tn=0;
for j=1:y %159 grammes 
    for i=1:x %87 stiles
        if IOUFinal(j,i)==1
            tn=tn+1;
            break;
        end
    end
end
fp=y-tn;

Recall=tp/(tp+fn);
Precision=tp/(tp+fp);
F1=2*( (Recall*Precision) / (Recall+Precision) );
% and show the results
fprintf('Recall %0.2f\n',Recall);
fprintf('Precision %0.2f\n',Precision);
fprintf('F-Measure %0.2f\n',F1);

