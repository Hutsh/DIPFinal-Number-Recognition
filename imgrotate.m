clear all;close all
Ic = imread('card\card2r2.jpg');%原图
figure,imshow(Ic);
I = rgb2gray(Ic);
[size_y size_x] = size(I);
I2 = imadjust(I, [0 0.8], [0 1]); 
BW = im2bw(I2);

se=strel('disk',round(size_y/50));
BW=imerode(BW,se);
BW=imdilate(BW,se);
BW2= imfill(BW,'holes');

bw = edge(BW2,'sobel','horizontal');
[m,n]=size(bw);
S=round(sqrt(m^2 + n^2));%S可以去到的最大值
ma = 180;
md = S;
r=zeros(md,ma);
for i=1:m
    for j=1:n
        if bw(i,j)==1
            for k=1:ma
                ru=round(abs(i*cos(k*3.14/180) + j*sin(k*3.14/180)));
                r(ru+1,k)=r(ru+1,k)+1; %用来记录交点数值和角度
            end
        end
    end
end
[m,n]=size(r);
for i=1:m
    for j=1:n
        if r(i,j)>r(1,1)
            r(1,1) = r(i,j);
            c=j;             %得到最大值的交点 的角度值
        end
    end
end
if c<=90
    rot=-c;
else
    rot=180-c;
end
robw=imrotate(BW2,rot,'crop');
roc =imrotate(Ic,rot,'crop');
figure,imshow(roc);
