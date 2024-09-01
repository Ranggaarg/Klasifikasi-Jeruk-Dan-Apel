function varargout = program_gui(varargin)
% PROGRAM_GUI MATLAB code for program_gui.fig
%      PROGRAM_GUI, by itself, creates a new PROGRAM_GUI or raises the existing
%      singleton*.
%
%      H = PROGRAM_GUI returns the handle to a new PROGRAM_GUI or the handle to
%      the existing singleton*.
%
%      PROGRAM_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PROGRAM_GUI.M with the given input arguments.
%
%      PROGRAM_GUI('Property','Value',...) creates a new PROGRAM_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before program_gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to program_gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help program_gui

% Last Modified by GUIDE v2.5 21-Nov-2023 20:33:10

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @program_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @program_gui_OutputFcn, ...
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


% --- Executes just before program_gui is made visible.
function program_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to program_gui (see VARARGIN)

% Choose default command line output for program_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
movegui (hObject, 'center');
% UIWAIT makes program_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = program_gui_OutputFcn(hObject, eventdata, handles) 
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


% Memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');

%Jika ada nama file yang dipilih maka akan mengeksekusi perintah dibawah
if ~isequal(nama_file, 0)
    % 
     % Membaca file citra rgb
    Img = imread(fullfile(nama_folder, nama_file));
     % Menampilkan citra rgb pada axes
    axes(handles.axes1)
    imshow(Img)
    title('Citra RGB')
    % Menampilkan nama file pada edit text
    set(handles.edit1,'String', nama_file)
    
    % Menyimpan variabel img pada lokasi handles agar dapat dipanggil oleh
    % push button yang lain
    handles.Img = Img;
    guidata(hObject, handles)
    
    else   
    % Jika tidak ada nama file maka akan kembali
    return
end
   
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memanggil variable Img yang ada dilokasi handles
Img = handles.Img;

 % Melakukan konversi citra rgb menjadi citra L*a*b
    cform = makecform('srgb2lab');
    lab = applycform(Img, cform);
    % figure, imshow(lab)
    % Mengekstrak komponen dari citra L*a*b
    a = lab(:,:,2);
    % figure, imshow(a)
    % Melakukan thresholding terhadap komponen a
    bw  = a > 140;
 %   figure, ims how(bw)
    % Melakukan operasi morfologi untuk menyempurnakan hasil segmentasi
    bw = imfill(bw,'holes');
    
    % Menampilkan citra biner hasil segmentasi
    axes(handles.axes2)
    imshow(bw)
    title('Citra Biner')
    
    % Menyimpan variabel bw pada lokasi handles agar dapat dipanggil oleh
    % push button yang lain
    handles.bw = bw;
    guidata(hObject, handles)
% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Memanggil variabel Img dan bw yang ada di handles
Img = handles.Img;
bw = handles.bw;
% Mengkonversi citra rgb menjadi citra hsv
    hsv = rgb2hsv(Img);
    % Mengekstrak komponen h dan s dari citra hsv
    h = hsv(:,:,1); %Hue
    s = hsv(:,:,2); %Saturasi
    % Mengubah nilai piksel background menjadi nol
    h(~bw) = 0;
    s(~bw) = 0;
    % Menghitung rata-rata nilai hue dan saturasi
    data_uji(1,1) = sum(sum(h))/sum(sum(bw));
    data_uji(1,2) = sum(sum(s))/sum(sum(bw));
    
    % Menampilkan data ciri pada tabel
    data_tabel = cell(2,2);
    data_tabel{1,1} = 'Hue';
    data_tabel{2,1} = 'Saturation';
    data_tabel{1,2} = num2str(data_uji(1,1));
    data_tabel{2,2} = num2str(data_uji(1,2));
    set(handles.uitable1,'Data',data_tabel,'RowName',1:2)
    
    % Menyimpan variabel data_uji pada lokasi handles agar dapat dipanggil oleh
    % push button yang lain
    handles.data_uji = data_uji;
    guidata(hObject, handles)
    
% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Memanggil variabel data_uji yang ada dilokasi handles
data_uji = handles.data_uji;

% Memanggil model hasil pelatihan
load Mdl

% Membaca kelas keluaran hasil pengujian
kelas_keluaran = predict(Mdl, data_uji);

% Menampilkan kelas keluaran hasil pengujian pada edit text
set(handles.edit2,'String', kelas_keluaran{1})
% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% mereset tampilan GUI
set(handles.edit1,'String',[])
set(handles.edit2,'String',[])

axes(handles.axes1)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[]) 

axes(handles.axes2)
cla reset
set(gca,'XTick',[])
set(gca,'YTick',[]) 

set(handles.uitable1,'Data',[],'RowName',{'' '' '' ''})

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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
