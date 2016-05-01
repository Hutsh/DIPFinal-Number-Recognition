clear all;close all
I = imread('card\card7r.jpg');%原图
I = rgb2gray(I);
figure,imshow(I)
I2 = imadjust(I, [0 0.8], [0 1]); 
BW = im2bw(I2);
BW2= imfill(BW,'holes');
BW2=medfilt2(BW2,[20,20]);
figure,imshow(BW2)
% binaryImage = edge(BW2,'canny'); % 'Canny' edge detector
% binaryImage = bwmorph(binaryImage,'thicken'); % A morphological operation for edge linking
% figure,imshow(binaryImage)

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
robw=imrotate(I,rot,'crop');
figure,imshow(robw);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure,imshow(I)
% for i = 1:3
%     I(:,:,i)=medfilt2(I(:,:,i),[3 3]);
% end
% hv = rgb2hsv(I);
% S=hv(:,:,3);
% [m n]=size(S);
% for i = 1:m
%     for j = 1:n
%         S(i,j) = S(i,j)*5;%提高亮度
%     end
% end
% figure,imshow(S);
% hv(:,:,3)=S;
% enhans = hsv2rgb(hv);%取红色通道
% figure,imshow(enhans(:,:,3));
% enhans(:,:,1)=enhans(:,:,3);enhans(:,:,2)=enhans(:,:,3);
% Rcard = rgb2gray(enhans);
% I2=im2bw(Rcard,0.6);
% figure,imshow(I2);%阈值
% 
% binaryImage = edge(I2,'canny'); % 'Canny' edge detector
% figure,imshow(binaryImage);%阈值

