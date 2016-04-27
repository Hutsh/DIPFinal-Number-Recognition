clear all;
I = imread('card2.jpg');
I1=rgb2gray(I);      %灰度处理，自动取值二值化
level=graythresh(I1);
I2=im2bw(I1,level);
imshow(I2)