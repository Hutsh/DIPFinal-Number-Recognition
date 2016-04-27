%定义函数功能切割
function e=qiege(d)
[m,n]=size(d);  %确定图像大小
top=1;bottom=m;left=1;right=n; %初始定义top bottom left right
%从第一行开始，自上而下，如果此行的和为0且top<=m ，则top自加一
%当不全是零的时候结束
while sum(d(top,:))==0 && top<=m  
    top=top+1;
end
%从最后一行开始，自下而上，如果此行的和为0且bottom>=1，则bottom自减一
%当不全是零的时候结束
while sum(d(bottom,:))==0 && bottom>=1
    bottom=bottom-1;
end
%从第一列开始，自左而右，如果此行的和为0且left<=n，则left自加一
%当不全是零的时候结束
while sum(d(:,left))==0 && left<=n
    left=left+1;
end
%从最后一列开始，自右而左，如果此行的和为0且left<=n，则right自减一
%当不全是零的时候结束
while sum(d(:,right))==0 && left<=n
    right=right-1;
end
%确定切割范围
dd=right-left;
hh=bottom-top;
e=imcrop(d,[left top dd hh]);