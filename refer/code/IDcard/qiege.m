%���庯�������и�
function e=qiege(d)
[m,n]=size(d);  %ȷ��ͼ���С
top=1;bottom=m;left=1;right=n; %��ʼ����top bottom left right
%�ӵ�һ�п�ʼ�����϶��£�������еĺ�Ϊ0��top<=m ����top�Լ�һ
%����ȫ�����ʱ�����
while sum(d(top,:))==0 && top<=m  
    top=top+1;
end
%�����һ�п�ʼ�����¶��ϣ�������еĺ�Ϊ0��bottom>=1����bottom�Լ�һ
%����ȫ�����ʱ�����
while sum(d(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
%�ӵ�һ�п�ʼ��������ң�������еĺ�Ϊ0��left<=n����left�Լ�һ
%����ȫ�����ʱ�����
while sum(d(:,left))==0 && left<=n
    left=left+1;
end
%�����һ�п�ʼ�����Ҷ���������еĺ�Ϊ0��left<=n����right�Լ�һ
%����ȫ�����ʱ�����
while sum(d(:,right))==0 && left<=n
    right=right-1;
end
%ȷ���иΧ
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);