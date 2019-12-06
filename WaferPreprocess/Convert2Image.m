function Convert2Image(varargin)
sparsity = 0; % Percentage to remove
pix = 512; 
close all
B37R = true;

targetFile = char(varargin);
ConfiAvailable = 0; % assumed to be off unless data is available
CalcDiff = 1; % we generally don't want to check this. 
coarseStep = 250;

DieRow_header   = 'Row';
SwathIdx_header = 'SwathIndex';
SubSwath_header = 'Sub';
Xpos_header     = 'Wafer X';
Ypos_header     = 'Wafer Y';    
ECS_header      = 'ECS BestFocus';
NSC_header      = 'NSCBestFocus';
Conf_header     = 'Confidence Level';

% Just incase we want to run this by itself without select data function
if isempty(varargin)
    %startPath = ('O:\DiagOutput');
    startPath = ('\\10.35.1.204\e$\DATA1010\KTInsptr1340013\Logs\10.10.928.2\DiagOutput\FM'); %Identify start location... may need to
    
    if B37R
        startPath = ('C:\Users\lcastane\Desktop\CS230\Project\FocusMapDataBase\FullWaferSP');
    end
    
    [filename, path] = uigetfile({'*FM*.fmi;*.zip','All Files (*.*)'},'Please select a focus map to analyze, or Zipped Session',startPath); % Select folder GUI with starting folder location
    targetFile = fullfile(path,filename);
end

% Small update to handel new zipped format, need to be able to write to
% C:\Temp\ location.. which shouldn't be a problem
if ~isempty(strfind(char(targetFile),'zip'))
    zipPath = targetFile;
    zipFiles = unzip(zipPath,'C:\Temp\');
    for i = 1:length(zipFiles)
        if ~isempty(strfind(char(zipFiles(i)),'FM.fmi'))
            targetFile = char(zipFiles(i));
            break
        end
    end
end

myData = importdata(targetFile);
numCols = size(myData.data,2);

% disp(strcat('The number of columns in the data:','_',num2str(numCols)));

if numCols > 6
    for i = 1:length(myData.colheaders)
        if ~isempty(strfind(char(myData.colheaders(i)),DieRow_header))
            dieRow = myData.data(:,i);
            dieRowLable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),SwathIdx_header))
            swathInx = myData.data(:,i);
            swathLable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),SubSwath_header))
            subSwath = myData.data(:,i);
            subSwathlable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),Xpos_header))
            x = myData.data(:,i);
            xlable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),Ypos_header))
            y = myData.data(:,i);
            ylable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),ECS_header))
            ECS = myData.data(:,i);
            ECSlable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),NSC_header))
            NSC = myData.data(:,i);
            NSClable = char(myData.colheaders(i));
        elseif ~isempty(strfind(char(myData.colheaders(i)),Conf_header))
            Confi = myData.data(:,i);
            Conflable = char(myData.colheaders(i));
            ConfiAvailable = 1;
        end
    end
else
    f = msgbox('This map format is no longer supported', 'Error','error');
    quit
end

% Quick Plot of Raw Data
% simpleScatterPlot(x,y,NSC,'Raw Data NSC')

% Fit Plane and Remove
[flatZ,~] = removeTilt(x,y,ECS); % Not using wafer plane
% simpleScatterPlot(x,y,flatZ,'Map Scatter Plot Without Wafer Tilt')

if CalcDiff
    % Get max ECS change rate
    [coarseX,coarseY,coarseZ] = diffPlot(x,y,flatZ,coarseStep);
end

% Normalize and scale to 256 & Generate additional images for data enhancement
imgZ = uint8((coarseZ-min(min(coarseZ)))/(max(max(coarseZ))-min(min(coarseZ)))*255);
imgZ_0 = flip(imgZ,1);

maskIndex    = randi(100,size(imgZ_0, 1),size(imgZ_0, 2));
mask = maskIndex >= sparsity; % Percentage of points removed
imgZ_0 = imgZ_0.*uint8(mask);

clearvars -except path files imgZ_0 pix targetFile

% Create the rotated images
imgZ_0 = imresize(imgZ_0,[pix pix]); 
imgZ_90 = imrotate(imgZ_0,90);
imgZ_180 = imrotate(imgZ_0,180);
imgZ_270 = imrotate(imgZ_0,270);

% Create mirrored images
imgZ_0_m = flip(imgZ_0,2); 
imgZ_90_m = imrotate(imgZ_0_m,90);
imgZ_180_m = imrotate(imgZ_0_m,180);
imgZ_270_m = imrotate(imgZ_0_m,270);

% Generate blurred images
blur = 4; % Larger values create more blur (blur by blur convolved)

imgZ_0_b        = uint8(conv2(imgZ_0,ones(blur)/blur^2,'same'));
imgZ_90_b       = uint8(conv2(imgZ_90,ones(blur)/blur^2,'same'));
imgZ_180_b      = uint8(conv2(imgZ_180,ones(blur)/blur^2,'same'));
imgZ_270_b      = uint8(conv2(imgZ_270,ones(blur)/blur^2,'same'));

imgZ_0_m_b      = uint8(conv2(imgZ_0_m,ones(blur)/blur^2,'same')); 
imgZ_90_m_b     = uint8(conv2(imgZ_90_m,ones(blur)/blur^2,'same'));
imgZ_180_m_b    = uint8(conv2(imgZ_180_m,ones(blur)/blur^2,'same'));
imgZ_270_m_b    = uint8(conv2(imgZ_270_m,ones(blur)/blur^2,'same'));

% Generate some similar images for data agumentaion
imageName = strcat(targetFile(1:end-4),'_0.png');
imwrite(imgZ_0,imageName)
imageName = strcat(targetFile(1:end-4),'_1.png');
imwrite(imgZ_90,imageName)
imageName = strcat(targetFile(1:end-4),'_2.png');
imwrite(imgZ_180,imageName)
imageName = strcat(targetFile(1:end-4),'_3.png');
imwrite(imgZ_270,imageName)

imageName = strcat(targetFile(1:end-4),'_4.png');
imwrite(imgZ_0_m,imageName)
imageName = strcat(targetFile(1:end-4),'_5.png');
imwrite(imgZ_90_m,imageName)
imageName = strcat(targetFile(1:end-4),'_6.png');
imwrite(imgZ_180_m,imageName)
imageName = strcat(targetFile(1:end-4),'_7.png');
imwrite(imgZ_180_m,imageName)

imageName = strcat(targetFile(1:end-4),'_8.png');
imwrite(imgZ_0_b,imageName)
imageName = strcat(targetFile(1:end-4),'_9.png');
imwrite(imgZ_90_b,imageName)
imageName = strcat(targetFile(1:end-4),'_10.png');
imwrite(imgZ_180_b,imageName)
imageName = strcat(targetFile(1:end-4),'_11.png');
imwrite(imgZ_270_b,imageName)

imageName = strcat(targetFile(1:end-4),'_12.png');
imwrite(imgZ_0_m_b,imageName)
imageName = strcat(targetFile(1:end-4),'_13.png');
imwrite(imgZ_90_m_b,imageName)
imageName = strcat(targetFile(1:end-4),'_14.png');
imwrite(imgZ_180_m_b,imageName)
imageName = strcat(targetFile(1:end-4),'_15.png');
imwrite(imgZ_270_m_b,imageName)

disp('Done with file!!') 
