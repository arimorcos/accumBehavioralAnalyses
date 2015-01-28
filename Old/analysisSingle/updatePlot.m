%updatePlot.m

%function to update the window plot

%ASM 6/21/12

function updatePlot(src,evnt,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData)

%get gui data
[winSize checks] = getUpdatedGUI(guiObjects);

%delete current axes
delete(gca);

%turn on calculating...
set(guiObjects.winText,'visible','on');
drawnow;

%calculate window
if isempty(procWinData) || oldWinSize ~= winSize
    procWinData = initProcWinData(data,procData.sessionTime,winSize,guiID);
end
[procWinData] = calcWindow(data,procData.sessionTime,winSize,procData.trialTimes,procData.turnList,...
    procWinData,leftMazes,whiteMazes,guiID,checks);

%turn off calculating...
set(guiObjects.winText,'visible','off');

%plot
plotWindowData(procWinData,guiID,checks,guiObjects);

oldWinSize = winSize;

%set callback for update button
set(guiObjects.update,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.leftCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.trialCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.percCorrCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.whiteCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.legendCheck,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});
set(guiObjects.winSize,'Callback',{@updatePlot,data,guiObjects,procData,leftMazes,whiteMazes,guiID,oldWinSize,procWinData});

end