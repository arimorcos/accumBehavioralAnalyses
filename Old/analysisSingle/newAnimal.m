%newAnimal.m

%function to reprocess data for a new animal

function newAnimal(src,evnt,guiObjects,folderList)
    global paths;
    
    anName = folderList(get(guiObjects.animalPopup,'Value')).name;
    
    if paths.whichPath
        origDir = cd([paths.archPath,'\',anName]);
    else    
        origDir = cd([paths.currPath,'\',anName]);
    end
    
    %recreate date list
    fileList = what;
    fileDates = cellfun(@(x) x(7:12),fileList.mat,'UniformOutput',false);
    fileDates = fileDates(cellfun(@(abc) isempty(strfind(abc,'_')),fileDates));
    fileDateNums = cellfun(@(x) datenum(x,'yymmdd'),fileDates);
    [~,ind] = max(fileDateNums);
    date = fileDates{ind};
    altFile = 0;
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
    
    if ~exist('exper') || ~exist('data') %#ok<*EXIST>
        display('No file on selected date. Please try again with another date or animal.');
        return;
    end
    
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
    
    %process (same as analysisSingle main file
    
    delete(gca);
    
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
    
    %set callback for module button
    exper2.variables.MazeLengthAhead = exper.variables.MazeLengthAhead;
    set(guiObjects.runModule,'Callback',{@moduleButtonCallback,guiObjects,data,exper2,procData});
    
    %set callback for update button
    set(guiObjects.update,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.leftCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.trialCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.percCorrCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.whiteCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.legendCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    set(guiObjects.winSize,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
    
    %reset date popup
    fileDir = cd(origDir);
    set(guiObjects.datePopup,'String',dateStrings,'Value',loadedFile,'Callback',{@newDate,fileList,guiObjects,fileDir});
    set(guiObjects.dateButtonRight,'Callback',{@changeDate,guiObjects,1,length(dateStringsCell),fileList,fileDir});
    set(guiObjects.dateButtonLeft,'Callback',{@changeDate,guiObjects,0,length(dateStringsCell),fileList,fileDir});

end