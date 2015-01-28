%runFunction.m

%function to create figure for run speed 

function runFunction(data,exper)

    if sum(diff(data(9,:))==1) <= 10 
        msgbox('Not enough trials to analyze');
        return;
    end

    [runGUIData] = runGUI();

    turnStartPerc = str2double(get(runGUIData.turnStart,'String'))/100;
    runStartPerc = str2double(get(runGUIData.runStart,'String'))/100;
    runEndPerc = str2double(get(runGUIData.runEnd,'String'))/100;
    
    %set callback for update button
    set(runGUIData.plotButton,'Callback',{@updateRunPlot,data,exper,runGUIData});
    
    [runData] = runSpeedPerc(data,exper,runStartPerc,runEndPerc);
    [turnData] = turnSpeed(data,exper,turnStartPerc);
    
    %set callback for export button
    set(runGUIData.exportButton,'Callback',{@assignToBase,runData,turnData});
    
    subplot('Position',[0.05 0.15 0.9 0.8]);
    plotHistRunSpeedGUI(runData,turnData);
    
end

function assignToBase(src,evnt,runData,turnData)
    assignin('base','runData',runData);
    assignin('base','turnData',turnData);
end