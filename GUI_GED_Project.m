function varargout = GUI_GED_Project(varargin)
% GUI_GED_PROJECT MATLAB code for GUI_GED_Project.fig
%      GUI_GED_PROJECT, by itself, creates a new GUI_GED_PROJECT or raises the existing
%      singleton*.
%
%      H = GUI_GED_PROJECT returns the handle to a new GUI_GED_PROJECT or the handle to
%      the existing singleton*.
%
%      GUI_GED_PROJECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_GED_PROJECT.M with the given input arguments.
%
%      GUI_GED_PROJECT('Property','Value',...) creates a new GUI_GED_PROJECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_GED_Project_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_GED_Project_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI_GED_Project

% Last Modified by GUIDE v2.5 12-Apr-2019 23:47:58

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GUI_GED_Project_OpeningFcn, ...
    'gui_OutputFcn',  @GUI_GED_Project_OutputFcn, ...
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


% --- Executes just before GUI_GED_Project is made visible.
function GUI_GED_Project_OpeningFcn(hObject, eventdata, handles, varargin)
global p  prc1 theallDATA
p.myData=[];
theallDATA=[];
prc1=0;
handles.output = hObject;
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_GED_Project_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Clear.
function Clear_Callback(hObject, eventdata, handles)
% hObject    handle to Clear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global p  prc1  traindata  testdata theallDATA
p.myData=[];
prc1=0;
traindata=[];
testdata=[];
set(handles.UploadData_value,'string','');
set(handles.text15,'string','');
set(handles.edit1,'string','');
set(handles.edit2,'string','');
set(handles.edit2,'BackgroundColor','white');
set(handles.TrinAccuracy_value,'string','');
set(handles.TestAccuracy_value,'string','');
set(handles.checkbox1,'value',0);
axis(handles.axes1);
plot(0)
theallDATA=[];
% --- Executes on button press in Download_Result.
function Download_Result_Callback(hObject, eventdata, handles)
% hObject    handle to Download_Result (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
winopen('output.txt')

% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% set(handles.GUI_GED_Project,'visible','off');
% set(handles.GUI_LogIN_GED_Project,'visible','on');
close;
function Running_Algorithm_Callback(hObject, eventdata, handles)
% hObject    handle to Running_Algorithm (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  traindata  testdata
set(handles.edit2,'string','Running...');
set(handles.edit2,'BackgroundColor','red');
[trainedClassifier,Accuracy, validationAccuracy,scores] = trainClassifier4(traindata.X,traindata.Y,testdata.X,testdata.Y);
set(handles.TrinAccuracy_value,'string',num2str(validationAccuracy));
set(handles.TestAccuracy_value,'string',num2str(Accuracy));

set(handles.edit2,'string','Done');
set(handles.edit2,'BackgroundColor','green');

axis(handles.axes1);
gscatter(traindata.X(:,1),traindata.X(:,2),traindata.Y)

hold on
plot(traindata.X(trainedClassifier.ClassificationSVM.IsSupportVector,1),...
    traindata.X(trainedClassifier.ClassificationSVM.IsSupportVector,2),'ko','MarkerSize',10);
legend('-1','1','SVM')
hold off

% --- Executes on button press in Evaluate_Training_Data.
function Evaluate_Training_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Evaluate_Training_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Evaluate_Testing_Data.
function Evaluate_Testing_Data_Callback(hObject, eventdata, handles)
% hObject    handle to Evaluate_Testing_Data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Load.
function Load_Callback(hObject, eventdata, handles)
global traindata
[filename1, pathname] = uigetfile( ...
    {'*.mat','MAT (*.mat)'},'open');

if(filename1~=0) %pour traiter le cas d'appayer sur annule
    fName = fullfile(pathname,filename1);
    fff=load(fName);
    d=fieldnames(fff);
    s=size(fff.(d{1}),2);
    traindata.X=fff.(d{1})(:,1:s-1);
    traindata.Y=fff.(d{1})(:,s);
    perm=randperm(size(traindata.X, 1));
    traindata.X = traindata.X(perm, :);
    traindata.Y = traindata.Y(perm, :);
    clear fff d s;
    set(handles.UploadData_value,'String',filename1);
end


% --- Executes on button press in OK_loadData.
function OK_loadData_Callback(hObject, eventdata, handles)
% hObject    handle to OK_loadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%trainedClassifier('data_set_ALL_AML_train.csv')






% --- Executes during object creation, after setting all properties.
function UploadData_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to UploadData_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global testdata
[filename2, pathname] = uigetfile( ...
    {'*.mat','MAT (*.mat)'},'open');

if(filename2~=0) %pour traiter le cas d'appayer sur annule
    fName = fullfile(pathname,filename2);
    fff=load(fName);
    d=fieldnames(fff);
    s=size(fff.(d{1}),2);
    testdata.X=fff.(d{1})(:,1:s-1);
    testdata.Y=fff.(d{1})(:,s);
    perm=randperm(size(testdata.X, 1));
    testdata.X = testdata.X(perm, :);
    testdata.Y = testdata.Y(perm, :);
    clear fff d s;
    set(handles.text15,'String',filename2);
end


function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
global prc1

prc1=str2double(get(hObject,'String'));

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global traindata testdata  prc1  theallDATA

if(~isempty(theallDATA))
    traindata.X=[];
    traindata.Y=[];
    testdata.X=[];
    testdata.Y=[];
    if(prc1~=0)
        
        [N,L]=size(theallDATA);
        
        nbrtrn=floor((prc1*N)/100);
        nbrtst=N-nbrtrn;
        traindata.X=[];
        traindata.Y=[];
        testdata.X=[];
        testdata.Y=[];
        %%%%%%%%%%%%%%%%%%%%%%%
        traindata.X=theallDATA(1:nbrtrn,1:L-1);
        traindata.Y=theallDATA(1:nbrtrn,L);
        testdata.X=theallDATA(nbrtrn+1:N,1:L-1);
        testdata.Y=theallDATA(nbrtrn+1:N,L);
        
        perm=randperm(size(traindata.X, 1));
        traindata.X = traindata.X(perm, :);
        traindata.Y = traindata.Y(perm, :);
        perm=randperm(size(testdata.X, 1));
        testdata.X = testdata.X(perm, :);
        testdata.Y = testdata.Y(perm, :);
        strinvl=['(' num2str(nbrtrn) ',' num2str(nbrtst) ')'];
        set(handles.text19,'string',strinvl);
    end
elseif(~isempty(traindata) && ~isempty(testdata))
    if(prc1==0)
        theallDATA=[];
    elseif(prc1~=0)
        theallDATA=[[traindata.X traindata.Y];[testdata.X testdata.Y]];
        [N,L]=size(theallDATA);
        
        nbrtrn=floor((prc1*N)/100);
        nbrtst=N-nbrtrn;
        traindata.X=[];
        traindata.Y=[];
        testdata.X=[];
        testdata.Y=[];
        %%%%%%%%%%%%%%%%%%%%%%%
        traindata.X=theallDATA(1:nbrtrn,1:L-1);
        traindata.Y=theallDATA(1:nbrtrn,L);
        testdata.X=theallDATA(nbrtrn+1:N,1:L-1);
        testdata.Y=theallDATA(nbrtrn+1:N,L);
        
        perm=randperm(size(traindata.X, 1));
        traindata.X = traindata.X(perm, :);
        traindata.Y = traindata.Y(perm, :);
        perm=randperm(size(testdata.X, 1));
        testdata.X = testdata.X(perm, :);
        testdata.Y = testdata.Y(perm, :);
        strinvl=['(' num2str(nbrtrn) ',' num2str(nbrtst) ')'];
        set(handles.text19,'string',strinvl);
    end
end
theallDATA=[];
% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global theallDATA traindata testdata
theallDATA=[];

[filename1, pathname] = uigetfile( ...
    {'*.mat','MAT (*.mat)'},'open');

if(filename1~=0) %pour traiter le cas d'appayer sur annule
    fName = fullfile(pathname,filename1);
    fff=load(fName);
    d=fieldnames(fff);
    s=size(fff.(d{1}),2);
    theallDATA=fff.(d{1})(:,1:s);
    
    clear fff d s;
    set(handles.checkbox1,'value',1);
end

% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function TrinAccuracy_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TrinAccuracy_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function TestAccuracy_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TestAccuracy_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes1
