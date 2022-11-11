clear all; clc;close all;

%read an image
b=imread('sat1.png');
figure(1);imshow(b),title('Satelite Image');



%gray scale conversion
%c=rgb2gray(b);
red=b(:,:,1);
green=b(:,:,2);
blue=b(:,:,3);
c=(0.59*red)+(0.30*green)+(0.11*blue);
figure(3);imshow(c),title('Gray Scale Image');

%complement the image
%d=imcomplement(c);
L=256;
d=(L-1)-c;
figure(4);imshow(d),title('Complemented Image');

%Binary conversion
thresh=160;
%e=imbinarize(d);
%e=im2double(d);
[rows,cols]=size(d);
for x=1:rows
    for y=1:cols
        if(d(x,y)>thresh)
            f(x,y)=1;
        else
            f(x,y)=0;
        end
    end
end
figure(5);imshow(f),title('Binary Image');

%Canny Edge
Canny_img = edge(f, 'Canny');
figure(6);imshow(Canny_img, []),title('Edge Detected Image');

%Filling holes
g=imfill(Canny_img,'holes');
figure(7);imshow(g),title('Filled Image');

%High Pass Filteration

fourier=fft2(g);
Do=20;
[row,col]=size(g);
high=zeros(row,col);
centeru=(row/2);
centerv=(col/2);
for i=1:row
    for j=1:col
        dist=sqrt(((i-(centeru)^2)+((j-(centerv))^2)));
        if dist>Do
            high(i,j)=1;
        else
            high(i,j)=0;
        end
    end
end
 h= high.*fourier;
 inverse_f=ifft2(h);
 real_img=real(inverse_f);
figure(8);imshow(real_img),title('High pass Filter Image');

%Cropping the area

crop=imcrop(real_img,[5,171,500,74]);
figure(9);imshow(crop),title('Croped Image');

%Blob Analysis
blob_analysis=vision.BlobAnalysis('MinimumBlobArea',20,...
    'MaximumBlobArea',300);
[objArea,objCenteroid,bboxOut]=step(blob_analysis,g);
Ishape=insertShape(real_img,'rectangle',bboxOut,'Linewidth',4,'color',[0 255 0]);
crop1=imcrop(Ishape,[5,171,400,74]);
figure(10);imshow(crop1),title('Blobed Image');
