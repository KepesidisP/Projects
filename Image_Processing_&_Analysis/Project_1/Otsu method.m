clc; clear; close all; format compact;
tic
I = imread('sonet.jpg');

T=0; %αρχικοποίηση του κατωφλίου
[row,col]=size(I);

tic
hist= imhist(I); %το ιστόγραμμα της εικόνας

all_s=zeros(1,255); %αρχικοποίηση πίνακα για ολα τα σ
       
while ~(T==255) %για τον υπολογισμό με κάθε Threshold 0-255
    m0=0;   %μεσος ορος 1
    m1=0;   %μεσος ορος 2
    s0=0;   %διασπορά 1
    s1=0;   %διασπορά 2
    w0=0;   %πιθανότητα κλάσης 1
    w1=0;   %πιθανότητα κλάσης 2

    for t=1:255 % για κάθε τιμή του ιστογράμματος

        if t<T %αν ανήκει πριν το κατώφλι 
           w0=w0 + (hist(t) / (row*col));  %πιθανότητα κλάσης 1
        else
           w1=w1 + (hist(t) / (row*col));  %πιθανότητα κλάσης 2
        end

    end

    % mean
    for t=1:255

        p=(hist(t) / (row*col));  %πιθανότητα κάθε πιξελ
        if t<T
           m0=m0 + (t*p);
        else
           m1=m1 + (t*p);
        end
       
    end
 
    m0=(1/w0) * m0;
    m1=(1/w1) * m1;
    
   %variance
   for t=1:255

       p=(hist(t+1) / (row*col));  %πιθανότητα κάθε πιξελ
       if t<T
           s0=s0+((t-m0)*(t-m0))*p;           
       else
           s1=s1+((t-m1)*(t-m1))*p;
       end

   end

   s0=(1/m0) * s0;
   s1=(1/m1) * s1;

   S=(w0*s0)+(w1*s1);
   all_s(T+1)=S; %αποθήκευση κάθε σ

   T=T+1;
       
end


minimum_s=find(all_s==(min(all_s))); %αναζήτηση της θέσης μικρότερης τιμής για το σ
Threshold=(minimum_s)/256;
toc

figure;
h = bar(0:255, hist, 'histc');
xline(Threshold*256,'-r','LineWidth',2)

disp([' T Value ,.is ' num2str(Threshold)]);
BW = imbinarize(I,Threshold);
figure;
imshowpair(I,BW,'montage')