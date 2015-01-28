%analysisSingle.m

%This function mirrors the online analysis function for post-hoc, single
%day analysis

%ASM 6/21/12

function analysisSingle(animal,date,altFile)

if nargin < 3
    altFile = 0;
end

if nargin < 2
    date = 0;
end

if nargin < 1
    noAn = true;
    animal = '';
else
    noAn = false;
end

if ~ischar(date) && date ~= 0
    days = date;
    date = now;
    date = addtodate(date,-days,'day');
    date = datestr(date,'yymmdd');
end

%change to data directory
global paths; 
paths.currPath = 'C:\DATA\Ari\Current Mice';
paths.archPath = 'C:\DATA\Ari\Archived Mice';
paths.whichPath = 0;
origDir = cd(paths.currPath);

%Get list of folders in directory
folderList = dir('AM*'); 
for i=1:size(folderList,1)
    if ~strcmpi(animal,folderList(i).name) && ~noAn
        continue;
    end
    if noAn
        noAn = false;
    end
    cd(folderList(i).name); %change to directory
    loadedAn = i;
    fileList = what;
    fileDates = cellfun(@(x) x(7:12),fileList.mat,'UniformOutput',false);
    fileDates = fileDates(cellfun(@(abc) isempty(strfind(abc,'_')),fileDates));
    if date == 0 
        fileDateNums = cellfun(@(x) datenum(x,'yymmdd'),fileDates);
        [~,ind] = max(fileDateNums);
        date = fileDates{ind};
    end
    findResult = strfind(fileList.mat,date);
    if sum(cellfun(@(x) ~isempty(x),findResult)) > 1
        altFileFlag = true;
        fileCount = 0;
    else
        altFileFlag = false;
    end
    for j=1:size(findResult,1)
        if ~isempty(findResult{j}) %determine if date is present in any files
            if altFileFlag
                fileCount = fileCount + 1;
                if fileCount == altFile + 1
                    load(fileList.mat{j},'exper','data'); %load that file
                    loadedFile = j;
                end
            else
                load(fileList.mat{j},'exper','data'); %load that file
                loadedFile = j;
            end
            
        end
    end    
end

if ~exist('exper') || ~exist('data') %#ok<*EXIST>
    display('No file on selected date. Please try again with another date or animal.');
    return;
end

%launch gui
[guiObjects] = GUI();

%set up animal change section 
anNames = arrayfun(@(x) x.name,folderList,'UniformOutput',false);
anNames =  cellfun(@(x)[x,'|'],anNames,'UniformOutput',false);
anNames = strcat(anNames{:});
anNames = anNames(1:end-1);

%set up date change section
dateStringsCell = fileDates;
for i=1:length(dateStringsCell)
    dateMatch = strcmp(dateStringsCell{i},dateStringsCell);
    if sum(dateMatch) > 1
        flag = 1;
        for j = 1:length(dateStringsCell)
            if dateMatch(j)
                if flag ~= 0 
                    dateStringsCell{j} = [dateStringsCell{j},'_',num2str(flag)];
                end
                flag = flag + 1;
            end
        end
    end
end

dateStrings = cellfun(@(x)[x,'|'],dateStringsCell,'UniformOutput',false);
dateStrings = strcat(dateStrings{:});
dateStrings = dateStrings(1:end-1);

%get the animal name, mazeID, mazeName, reshapeSize, guiID
anName = ['AM',exper.variables.mouseNumber];
mazeName = func2str(exper.experimentCode);
guiID = str2double(exper.variables.guiID);
[leftMazes] = getLeftMazes(exper);
[whiteMazes] = getWhiteMazes(exper);
oldWinSize = str2double(get(guiObjects.winSize));
procWinData = [];

%Add info to GUI Title
titleString = ['Live ViRMEn Data -- Animal ',anName,' -- Maze ',mazeName];
set(guiObjects.figHandle,'Name',titleString);

%process the data
[procData] = processData(data,exper,guiID);

%convert to table 
[tableInfo] = convertToTable(procData,guiID);

%update table - use guiID to determine which guiID will be set
updateTableSingle(procData,tableInfo,guiObjects);

%update raster plot
plotTrialRaster(procData);

%set callback for update button
set(guiObjects.update,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.leftCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.trialCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.percCorrCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.whiteCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.legendCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.winSize,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});

%set callback for module button
set(guiObjects.runModule,'Callback',{@moduleButtonCallback,guiObjects,data,exper,procData});

%change back to original directory
fileDir = cd(origDir);
set(guiObjects.datePopup,'String',dateStrings,'Value',loadedFile,'Callback',{@newDate,fileList,guiObjects,fileDir});
set(guiObjects.dateButtonRight,'Callback',{@changeDate,guiObjects,1,length(dateStringsCell),fileList,fileDir});
set(guiObjects.dateButtonLeft,'Callback',{@changeDate,guiObjects,0,length(dateStringsCell),fileList,fileDir});
set(guiObjects.animalPopup,'String',anNames,'Value',loadedAn,'Callback',{@newAnimal,guiObjects,folderList});
set(guiObjects.animalButtonRight,'Callback',{@changeAnimal,guiObjects,1,length(folderList),folderList});
set(guiObjects.animalButtonLeft,'Callback',{@changeAnimal,guiObjects,0,length(folderList),folderList});
set(guiObjects.mouseToggle,'Callback',{@changeMouseDir,guiObjects});
end