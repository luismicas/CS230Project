function ConvertMaps2Images(varargin)
B37R = true;

if isempty(varargin)
    %startPath = ('O:\DiagOutput');
    startPath = ('\\10.35.1.204\e$\DATA1010\KTInsptr1340013\Logs\10.10.928.2\DiagOutput\FM'); %Identify start location... may need to
    
    if B37R
        startPath = ('C:\Users\lcastane\Desktop\CS230\Project\FocusMapDataBase\FullWaferSP\PA2_b37r\RawFullWaferMaps');
    end
    
    [filename, path] = uigetfile({'*FM*.fmi;*.zip','All Files (*.*)'},'Please select a focus map to analyze, or Zipped Session',startPath); % Select folder GUI with starting folder location
    targetFile = fullfile(path,filename);
end

files = dir(path);

for i = 1: length(files)
    if contains(files(i,1).name, '.fmi')
        Convert2Image(fullfile(files(i,1).folder,files(i,1).name))
    end
end

disp('Done with all files!!') 