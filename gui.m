function varargout = gui(varargin)
% GUI MATLAB code for gui.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui

% Last Modified by GUIDE v2.5 12-Jun-2016 00:57:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_OutputFcn, ...
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


% --- Executes just before gui is made visible.
function gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui (see VARARGIN)

% Load configs and precomputed variables
make_globals(1)
global piano_img
global t;

% Choose default command line output for gui
handles.output = hObject;
handles.recording = 0;
handles.record = zeros(1, length(t));


% plot the piano
axes(handles.axes1);
imageHandle = imshow(piano_img); hold on;
% callback to play the piano
set(imageHandle,'ButtonDownFcn',@ImageClickCallback);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function ImageClickCallback ( objectHandle , eventData)
global Fs;
handles = guidata(objectHandle);
% get mouse click position
axesHandle  = get(objectHandle,'Parent');
coordinates = get(axesHandle,'CurrentPoint'); 
coordinates = coordinates(1,1:2);
% get key number
note = key_from_position(coordinates(1), coordinates(2));
% play 
signal = piano_key(note);
sound(signal, Fs);
% if recording accumulate signal
if(handles.recording)
    handles.record = handles.record + signal;
end
% Update handles structure
guidata(objectHandle, handles);




% --- Outputs from this function are returned to the command line.
function varargout = gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
global mapper;
global Fs;

if(isKey(mapper, eventdata.Key))
    note = mapper(eventdata.Key);
    signal = piano_key(note);
    sound(signal, Fs);
    %if recording accumulate signal
    if(handles.recording)
        handles.record = handles.record + signal;
    end
    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on key release with focus on figure1 and none of its controls.
function figure1_KeyReleaseFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see FIGURE)
%	Key: name of the key that was released, in lower case
%	Character: character interpretation of the key(s) that was released
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) released
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenuFs.
function popupmenuFs_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuFs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuFs

%set sampling rate
global Fs;
contents = cellstr(get(hObject,'String'));
Fs = str2num(contents{get(hObject,'Value')});
make_globals(0);
global t;
% reset record
handles.record = zeros(1, length(t));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function popupmenuFs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuFs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


 
% --- Executes on slider movement.
function sliderTlen_Callback(hObject, eventdata, handles)
% hObject    handle to sliderTlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

global tlen;
tlen = get(hObject,'Value') * 5;
make_globals(0);
global t;
% reset record
handles.record = zeros(1, length(t));
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function sliderTlen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderTlen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderAttenuation_Callback(hObject, eventdata, handles)
% hObject    handle to sliderAttenuation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global attenuation_coef;
attenuation_coef = get(hObject,'Value') * 20;
make_globals(0);

% --- Executes during object creation, after setting all properties.
function sliderAttenuation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderAttenuation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function sliderOvertone_Callback(hObject, eventdata, handles)
% hObject    handle to sliderOvertone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global overtone;
overtone = 3 * get(hObject,'Value');
make_globals(0);

% --- Executes during object creation, after setting all properties.
function sliderOvertone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sliderOvertone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbuttonRecord.
function pushbuttonRecord_Callback(hObject, eventdata, handles)
% hObject    handle to pushbuttonRecord (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Fs;
global t;

if(handles.recording)
    set(hObject,'string', 'record')
    handles.recording = 0;
    % normalize record
    handles.record = handles.record / max(abs(handles.record));
    % save chord
    audiowrite('chord.wav', handles.record, Fs);
    % reset record
    handles.record = zeros(1, length(t));
else
    set(hObject,'string', 'save')
    handles.recording = 1;
end
% % Update handles structure
guidata(hObject, handles);
