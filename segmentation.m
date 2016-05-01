clear all;close all
Ic = imread('card\card5.jpg');%原图
I = rgb2gray(Ic);
[size_y size_x] = size(I);
figure,imshow(I)
I2 = imadjust(I, [0 0.8], [0 1]); 
BW = im2bw(I2);
% figure,imshow(BW);
% BW=medfilt2(BW,[round(size_x/100),round(size_x/100)]);
% figure,imshow(BW);
se=strel('disk',round(size_y/50));
BW=imerode(BW,se);
% figure,imshow(BW)
BW=imdilate(BW,se);
% figure,imshow(BW)

BW2= imfill(BW,'holes');
% figure,imshow(BW2)
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
robw=imrotate(BW2,rot,'crop');
roc =imrotate(Ic,rot,'crop');
figure,imshow(robw);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%左上到右下%%%%%%%%%%%%%5
ltok=0;rbok=0;%坐上
for n = 2:min(size_x,size_y)%第N条
    for i = 1:n-1
        testltx=i;testlty=n-i;
        if robw(testlty,testltx)==1;
            if ltok==0
                lt_x = testltx;lt_y = testlty;
                ltok=1;
            else
                ltok=1;
            end;
        end
        testrby=size_y-i+1;testrbx=size_x-n+i;
        if robw(testrby,testrbx) == 1
            if rbok==0
                rb_x = testrbx;rb_y = testrby;
                rbok=1;
            else
                rbok=1;
            end;
        end
        if ltok+rbok == 2
            break;
        end
    end
    if ltok+rbok == 2
            break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%左上到右下%%%%%%%%%%%%%5

%%%%%%%%%%%%%%%%%%%%%%%%%%%%左下到右上%%%%%%%%%%%%%5
lbok=0;rtok=0;%左上到右下
for n = 2:min(size_x,size_y)%第N条
    for i = 1:n-1
        testlby=size_y-n+i+1;testlbx=i;
        if robw(testlby,testlbx)==1;%左下
            if lbok==0
                lb_x = testlbx;lb_y = testlby;
                lbok=1;
            else
                lbok=1;
            end;
        end
        testrty=i;testrtx=size_x-n+i+1;
        if robw(testrty,testrtx) == 1
            if rtok==0
                rt_x = testrtx;rt_y = testrty;
                rtok=1;
            else
                rtok=1;
            end;
        end
        if lbok+rtok == 2
            break;
        end
    end
    if lbok+rtok == 2
            break;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%左下到右上%%%%%%%%%%%%%5

for i=-1:1
    for j=-1:1
        roc(lt_y+i,lt_x+j,1)=255;
        roc(rb_y+i,rb_x+j,1)=255;
        roc(lt_y+i,lt_x+j,2)=0;
        roc(rb_y+i,rb_x+j,2)=0;
        roc(lt_y+i,lt_x+j,3)=0;
        roc(rb_y+i,rb_x+j,3)=0;
        roc(lb_y+i,lb_x+j,1)=255;
        roc(rt_y+i,rt_x+j,1)=255;
        roc(lb_y+i,lb_x+j,2)=0;
        roc(rt_y+i,rt_x+j,2)=0;
        roc(lb_y+i,lb_x+j,3)=0;
        roc(rt_y+i,rt_x+j,3)=0;
    end
end
figure,imshow(roc);

height_l=round((lb_y-lt_y)/0.95);%左边两点之差除以0.95约等于卡片高度
height_r=round((rb_y-rt_y)/0.95);
width_t=round((rt_x-lt_x)/0.97);
width_b=round((rb_x-lb_x)/0.97);

crop_lt_x = round(lt_x-(width_t-(rt_x-lt_x))/2);
crop_lt_y = round(lt_y-(height_l-(lb_y-lt_y))/2);
crop_lb_x = round(lb_x-(width_b-(rb_x-lb_x))/2);
crop_lb_y = round(lb_y+(height_l-(lb_y-lt_y))/2);
crop_rt_x = round(rt_x+(width_t-(rt_x-lt_x))/2);
crop_rt_y = round(rt_y-(height_r-(rb_y-rt_y))/2);
crop_rb_x = round(rb_x+(width_b-(rb_x-lb_x))/2);
crop_rb_y = round(rb_y+(height_r-(rb_y-rt_y))/2);

for i=-1:1
    for j=-1:1
        roc(crop_lt_y+i,crop_lt_x+j,1)=255;
        roc(crop_rb_y+i,crop_rb_x+j,1)=255;
        roc(crop_lt_y+i,crop_lt_x+j,2)=0;
        roc(crop_rb_y+i,crop_rb_x+j,2)=0;
        roc(crop_lt_y+i,crop_lt_x+j,3)=0;
        roc(crop_rb_y+i,crop_rb_x+j,3)=0;
        roc(crop_lb_y+i,crop_lb_x+j,1)=255;
        roc(crop_rt_y+i,crop_rt_x+j,1)=255;
        roc(crop_lb_y+i,crop_lb_x+j,2)=0;
        roc(crop_rt_y+i,crop_rt_x+j,2)=0;
        roc(crop_lb_y+i,crop_lb_x+j,3)=0;
        roc(crop_rt_y+i,crop_rt_x+j,3)=0;
    end
end
figure,imshow(roc);



        



% binaryImage = edge(robw,'canny'); % 'Canny' edge detector
% binaryImage = bwmorph(binaryImage,'thicken'); % A morphological operation for edge linking
% figure,imshow(binaryImage)

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

