A=imread('D:\1.jpg');  %读入图像
I1=rgb2gray(A);      %灰度处理，自动取值二值化
level=graythresh(I1);  
I2=im2bw(I1,level);
I3=~I2;                 
I4=bwareaopen(I3,25); %降噪处理
I=~I4;
[y x]=size(I);   %先确定身份证号码所在的大概区域
 A2=imcrop(I,[x/3 y/2 2*x/3 y/2]);
figure,imshow(A2)
se = strel('square',40);  %进行开运算，使图像形成几个连通域
bw= imopen(A2,se);
figure,imshow(bw)
 %寻找不包括孔连通域的边缘，并且把每个连通域的边界描出来
[B,L] = bwboundaries(bw,4); 
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
 boundary = B{k};
 plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
% 找到每个连通域的质心
stats = regionprops(L,'Area','Centroid');
% 循环历遍每个连通域的边界
for k = 1:length(B)
  % 获取一条边界上的所有点
  boundary = B{k};
  % 计算边界周长
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  % 获取边界所围面积
  area = stats(k).Area;
  % 计算匹配度
  metric =80*area/perimeter^2;
  % 要显示的匹配度字串
  metric_string = sprintf('%2.2f',metric);
  % 标记出匹配度接近1的连通域
  if metric >= 0.8 && metric <= 1.1
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');

    % 提取该连通域所对应在二值图像中的矩形区域
    goalboundary = boundary; 
    s = min(goalboundary, [], 1);
    e = max(goalboundary, [], 1);
  %将目标区域分别向两侧延伸7个像素
  goal = imcrop(A2,[s(2)-7 s(1) e(2)-s(2)+14 e(1)-s(1)]); 
  end
  % 显示匹配度字串
  text(boundary(1,2)-35,boundary(1,1)+13,...
    metric_string,'Color','g',...
'FontSize',14,'FontWeight','bold');
end
goal = ~goal;   %将目标区域进行反处理
figure,imshow(goal)
%求出目标区域的长度，并且求出等分为18个字符之后的长度
cs=size(goal,2); 
sz=cs/18;   
%定义变量t1 t2,分别为每个切割的起点和终点，以及它们的计算方法
t1=(0:17)*sz+1;t2=(1:18)*sz; 
figure;
k=0;
%将目标区域从左至右开始切割提取
for i=1:18
    temp=goal(:,t1(i):t2(i), :);
    temp=bwareaopen(temp,20); %对切割后的图像做降噪处理
    temp=qiege(temp);    %提取子函数，对图像进一步处理，去除每个字符旁边的全零行
    temp=imresize(temp,[30,20])  %将得到的图像重新定义成标准形式
    k=k+1;
    subplot(1,18,k);  %在一个窗口同时显示最后得到的字符
    imshow(temp);
end
