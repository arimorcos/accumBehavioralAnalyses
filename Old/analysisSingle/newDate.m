%newDate.m

%function to reprocess data for a new date

function newDate(src,evnt,fileList,guiObjects,fileDir)
    
    origDir = cd(fileDir);

    %load proper file
    load(fileList.mat{get(guiObjects.datePopup,'Value')},'data','exper');
    
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
    
    cd(origDir);
end