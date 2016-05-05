function varargout = numrec(varargin)
% NUMREC MATLAB code for numrec.fig
%      NUMREC, by itself, creates a new NUMREC or raises the existing
%      singleton*.
%
%      H = NUMREC returns the handle to a new NUMREC or the handle to
%      the existing singleton*.
%
%      NUMREC('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NUMREC.M with the given input arguments.
%
%      NUMREC('Property','Value',...) creates a new NUMREC or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before numrec_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to numrec_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help numrec

% Last Modified by GUIDE v2.5 04-May-2016 17:40:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @numrec_OpeningFcn, ...
                   'gui_OutputFcn',  @numrec_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before numrec is made visible.
function numrec_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to numrec (see VARARGIN)

% Choose default command line output for numrec
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes numrec wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = numrec_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
  flag =0;
  a=findobj('tag','pushbutton1');
  set(a,'userdata',flag);
 %set(handles.a,'userdata',flag);
[filename,pathname]=uigetfile({'*.*';'*.bmp';'*.jpg';'*.tif';'*.jpg'},'选择图像');
if isequal(filename,0)||isequal(pathname,0)
  errordlg('您还没有选取图片！！','温馨提示');%如果没有输入，则创建错误对话框 
  return;
else
    image=[pathname,filename];%合成路径+文件名
    im=imread(image);%读取图
    %set(handles.a,'userdata',flag);
    %set(handles.axes1,'HandleVisibility','ON');%打开坐标，方便操作
    axes(handles.axes1);%%使用图像，操作在坐标1
    imshow(im);%在坐标axes1显示原图像
    flag = 1;
    a=findobj('tag','pushbutton1');
    set(a,'userdata',flag);
    title('原始图像');
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   % flag=get(handles.a,'userdata');
    a=findobj('tag','pushbutton1');
    flag = get(a,'userdata');
 if flag == 1
   h=findobj('tag','pushbutton7');%先找到button7的句柄值
   set(h,'Enable','on');
   Ic=getimage(handles.axes1);
  I = rgb2gray(Ic);
[size_y,size_x] = size(I);
% x=findobj('tag','pushbutton2');
% set(x,'userdata',size_x);
% y=findobj('tag','pushbutton2');
% set(y,'userdata',size_y);
% figure,imshow(I)
I2 = imadjust(I, [0 0.8], [0 1]); 
BW = im2bw(I2);

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

%%%%%%%%%%%%%%%%%%%%%倾斜矫正↓%%%%%%%%%%%%%%%%%%%%%%%
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
imshow(roc);

%%%%%%%%%%%%%%%%%%%%%倾斜矫正↑%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%显示检测角↓%%%%%%%%%%%%%
% for i=-1:1
%     for j=-1:1
%         roc(lt_y+i,lt_x+j,1)=255;
%         roc(rb_y+i,rb_x+j,1)=255;
%         roc(lt_y+i,lt_x+j,2)=0;
%         roc(rb_y+i,rb_x+j,2)=0;
%         roc(lt_y+i,lt_x+j,3)=0;
%         roc(rb_y+i,rb_x+j,3)=0;
%         roc(lb_y+i,lb_x+j,1)=255;
%         roc(rt_y+i,rt_x+j,1)=255;
%         roc(lb_y+i,lb_x+j,2)=0;
%         roc(rt_y+i,rt_x+j,2)=0;
%         roc(lb_y+i,lb_x+j,3)=0;
%         roc(rt_y+i,rt_x+j,3)=0;
%     end
% end
% figure,imshow(roc);
%%%%%%%%%%%%显示检测角↑%%%%%%%%%%%%%

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

%%%%%%%%%%%%显示检测角↓%%%%%%%%%%%%%
% for i=-1:1
%     for j=-1:1
%         roc(crop_lt_y+i,crop_lt_x+j,1)=255;
%         roc(crop_rb_y+i,crop_rb_x+j,1)=255;
%         roc(crop_lt_y+i,crop_lt_x+j,2)=0;
%         roc(crop_rb_y+i,crop_rb_x+j,2)=0;
%         roc(crop_lt_y+i,crop_lt_x+j,3)=0;
%         roc(crop_rb_y+i,crop_rb_x+j,3)=0;
%         roc(crop_lb_y+i,crop_lb_x+j,1)=255;
%         roc(crop_rt_y+i,crop_rt_x+j,1)=255;
%         roc(crop_lb_y+i,crop_lb_x+j,2)=0;
%         roc(crop_rt_y+i,crop_rt_x+j,2)=0;
%         roc(crop_lb_y+i,crop_lb_x+j,3)=0;
%         roc(crop_rt_y+i,crop_rt_x+j,3)=0;
%     end
% end
% figure,imshow(roc);
%%%%%%%%%%%%显示检测角↑%%%%%%%%%%%%%

% fixedpoints=[crop_lt_x crop_lt_y;crop_rt_x crop_rt_y;crop_lb_x crop_lb_y;crop_rb_x crop_rb_y];
% movingpoints=[0 0;size_x 0;0 size_y;size_x size_y];
% 
% tform = fitgeotrans(movingpoints,fixedpoints,'Projective');

cropimg = imcrop(roc,[crop_lt_x crop_lt_y min(crop_rb_x-crop_lb_x,crop_rt_x-crop_lt_x) min(crop_rb_y-crop_rt_y,crop_lb_y-crop_lt_y)]);

imshow(cropimg);

%   setimage(handles.axes1);


    
 else      
   h=errordlg('没有选择图片','错误');  
   ha=get(h,'children');  
  
   hu=findall(allchild(h),'style','pushbutton');  
   set(hu,'string','确定');  
   ht=findall(ha,'type','text');  
   set(ht,'fontsize',20,'fontname','隶书'); 
 end
      

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
