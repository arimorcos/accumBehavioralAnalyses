%startOnlineAq.m

%function called when start button on GUI is pressed. Starts acquisition by
%pulling exper file and data array until stopped

%ASM 6/13/12

function startOnlineAq(src,eventdata,guiObjects)
    global shouldOnline;
    
    %set update interval
    updateInterval = 2;
    
    %change start button
    set(guiObjects.start,'String','Running...','ForegroundColor',[0 0.6 0]);
    
    %define path
    path = '\\HARVEYRIG1\Temporary';
    
    %use this global to determine whether the while loop should run. The
    %stop function sets it to false
    shouldOnline = true;
    
    %get the experiment file 
    if exist([path,'/tempStorage.mat']) == 2
        [exper] = copyExper(path);
    else
        stopOnlineAq(guiObjects.start,[],guiObjects);
    end

    %get the animal name, mazeID, mazeName, reshapeSize, guiID
    anName = ['AM',exper.variables.mouseNumber];
    mazeName = func2str(exper.experimentCode);
    reshapeSize = str2double(exper.variables.reshapeSize);
    guiID = str2double(exper.variables.guiID);
    [leftMazes] = getLeftMazes(exper);
    [whiteMazes] = getWhiteMazes(exper);
    exper2.variables.MazeLengthAhead = exper.variables.MazeLengthAhead;
    
    %get condition information
    [condInfo] = getCondInfo(leftMazes,whiteMazes);
    
    %Add info to GUI Title
    titleString = ['Live ViRMEn Data -- Animal ',anName,' -- Maze ',mazeName];
    set(guiObjects.figHandle,'Name',titleString);
    
    %initialize winData
    winData = NaN;
    winDataFlag = false;
    oldWinSize = str2double(get(guiObjects.winSize,'String'));
    
    while shouldOnline
        loopStartTime = tic;
        
        %get scroll bar position
        [vscroll vscrollPos] = getScrollBarPos(guiObjects);
        
        %check for new lastX and sessionTime
        [winSize lastX sessionTimeVector oldWinSize reCalcWinFlag checks shouldPause] = getGUIData(guiObjects,oldWinSize);
        
        if shouldPause
            continue;
        end
                    
        %get data
        [data] = copyData(path,reshapeSize);
        
        %turn on calculating text
        if reCalcWinFlag
            set(guiObjects.calcText,'visible','on');
            drawnow;
        end
        
        %process data
        [procData winDataFlag] = processLiveData(data,exper,lastX,winSize,winData,winDataFlag,guiID,reCalcWinFlag,checks);
        
        %convert procData into table format
        [tableInfo] = convertToTableFormat(procData,guiID,lastX);
        
        %update table - use guiID to determine which guiID will be set
        updateTable(procData,tableInfo,guiObjects);
        vscroll.setValue(vscrollPos);
        drawnow expose update;
        
        %set condition info
        set(guiObjects.condText,'String',condInfo{data(7,end)});
                
        %update raster plot
        plotTrialRaster(procData);
        
        %update sliding window plot 
        set(guiObjects.calcText,'visible','off');
        if procData.sessionTime > winSize
            set(guiObjects.winText,'visible','off');
            [guiObjects] = plotWindowData(procData.procWinData,guiID,checks,guiObjects);
        else
            axesHandles = findall(guiObjects.figHandle,'type','axes');
            if length(axesHandles) > 2
                delete(axesHandles(3));
            end
            set(guiObjects.winText,'visible','on');
        end
        
        %check if time has elapsed
        timeCheck(guiObjects,procData.sessionTimeVector,sessionTimeVector,titleString);
       
        %store winData
        winData = procData.procWinData;
                                                                                                                                                        
        %set scroll bar position
%         vscroll.setValue(vscrollPos);
        
        %prevent loop until updateInterval elapsed
        while toc(loopStartTime) < updateInterval 
            pause(.05);
        end
        
        %set callback for module button
        set(guiObjects.runModule,'Callback',{@moduleButtonCallback,guiObjects,data,exper2,procData});
        
%         %change focus of axes
%         if isfield(guiObjects,'windowPlot')
%             axes(guiObjects.windowPlot);
%         end
        clear data procData;
        
    end 

end