clear; close all; format compact; % Initialize
% για την χρονομέτρηση πρέπει να δοκιμαστεί ξεχωριστά κάθε κομμάτι υπολογισμών.
I = imread('sonet.jpg'); % Import and plot the histogram

C=10
R=25  % size of filter
A=im2double(I);


tic
%MEAN
                                        %filt=fspecial("average",R);
meanR=colfilt(A,[R R],"sliding",@mean); %imfilter(A,filt);
if ~(C==0)
    t1=((meanR*256)-C)/256;
    BW1 = imbinarize(I,t1);
else
    t1=meanR;
    BW1 = imbinarize(I,t1);
end
toc


tic
% MEDIAN
medianR= colfilt(A,[R R],"sliding",@median);  %medfilt2(A,[R R],"symmetric");
if ~(C==0)
    t2=((medianR*256)-C)/256;
    BW2 = imbinarize(I,t2);
else
    t2=medianR;
    BW2 = imbinarize(I,t2);
end
toc


tic
%Endiamesi (max+min)/2 -C

%fun1 = @(x) max(x(:));
maxR = colfilt(A,[R R],"sliding",@max); %nlfilter(A,[R R],fun1);
maxR=maxR*256;


%fun2 = @(x) min(x(:));
minR = colfilt(A,[R R],"sliding",@min); %nlfilter(A,[R R],fun2);
minR=minR*256;

if ~(C==0)
    t3=((maxR+minR)/2)-C;
else
    t3=((maxR+minR)/2);
end

t3=t3/256;
BW3 = imbinarize(I,t3);
toc

montage({I,BW1,BW2,BW3})