A=imread('D:\1.jpg');  %����ͼ��
I1=rgb2gray(A);      %�Ҷȴ����Զ�ȡֵ��ֵ��
level=graythresh(I1);  
I2=im2bw(I1,level);
I3=~I2;                 
I4=bwareaopen(I3,25); %���봦��
I=~I4;
[y x]=size(I);   %��ȷ�����֤�������ڵĴ������
 A2=imcrop(I,[x/3 y/2 2*x/3 y/2]);
figure,imshow(A2)
se = strel('square',40);  %���п����㣬ʹͼ���γɼ�����ͨ��
bw= imopen(A2,se);
figure,imshow(bw)
 %Ѱ�Ҳ���������ͨ��ı�Ե�����Ұ�ÿ����ͨ��ı߽������
[B,L] = bwboundaries(bw,4); 
imshow(label2rgb(L, @jet, [.5 .5 .5]))
hold on
for k = 1:length(B)
 boundary = B{k};
 plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)
end
% �ҵ�ÿ����ͨ�������
stats = regionprops(L,'Area','Centroid');
% ѭ������ÿ����ͨ��ı߽�
for k = 1:length(B)
  % ��ȡһ���߽��ϵ����е�
  boundary = B{k};
  % ����߽��ܳ�
  delta_sq = diff(boundary).^2;    
  perimeter = sum(sqrt(sum(delta_sq,2)));
  % ��ȡ�߽���Χ���
  area = stats(k).Area;
  % ����ƥ���
  metric =80*area/perimeter^2;
  % Ҫ��ʾ��ƥ����ִ�
  metric_string = sprintf('%2.2f',metric);
  % ��ǳ�ƥ��Ƚӽ�1����ͨ��
  if metric >= 0.8 && metric <= 1.1
    centroid = stats(k).Centroid;
    plot(centroid(1),centroid(2),'ko');

    % ��ȡ����ͨ������Ӧ�ڶ�ֵͼ���еľ�������
    goalboundary = boundary; 
    s = min(goalboundary, [], 1);
    e = max(goalboundary, [], 1);
  %��Ŀ������ֱ�����������7������
  goal = imcrop(A2,[s(2)-7 s(1) e(2)-s(2)+14 e(1)-s(1)]); 
  end
  % ��ʾƥ����ִ�
  text(boundary(1,2)-35,boundary(1,1)+13,...
    metric_string,'Color','g',...
'FontSize',14,'FontWeight','bold');
end
goal = ~goal;   %��Ŀ��������з�����
figure,imshow(goal)
%���Ŀ������ĳ��ȣ���������ȷ�Ϊ18���ַ�֮��ĳ���
cs=size(goal,2); 
sz=cs/18;   
%�������t1 t2,�ֱ�Ϊÿ���и�������յ㣬�Լ����ǵļ��㷽��
t1=(0:17)*sz+1;t2=(1:18)*sz; 
figure;
k=0;
%��Ŀ������������ҿ�ʼ�и���ȡ
for i=1:18
    temp=goal(:,t1(i):t2(i), :);
    temp=bwareaopen(temp,20); %���и���ͼ�������봦��
    temp=qiege(temp);    %��ȡ�Ӻ�������ͼ���һ������ȥ��ÿ���ַ��Աߵ�ȫ����
    temp=imresize(temp,[30,20])  %���õ���ͼ�����¶���ɱ�׼��ʽ
    k=k+1;
    subplot(1,18,k);  %��һ������ͬʱ��ʾ���õ����ַ�
    imshow(temp);
end
