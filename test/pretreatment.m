clear all;
I = imread('card2.jpg');
I1=rgb2gray(I);      %�Ҷȴ����Զ�ȡֵ��ֵ��
level=graythresh(I1);
I2=im2bw(I1,level);
imshow(I2)