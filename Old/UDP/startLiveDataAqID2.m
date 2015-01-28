%function startLiveDataAqID2.m

%function to start live data acquisition from ViRMen engine on another
%computer

function startLiveDataAqID2(src,evnt)
    global shouldAcquire;  
    global udpID;
    global guiText;
    
    shouldAcquire = true;
    
    beepFlag = false;
    
    if strcmpi(get(udpID,'Status'),'closed')
        fopen(udpID);     
        display('Data Acquisition Started');
    else
        display('Data Acquisition Already Running');
    end
    
    timeOverFlag = false;

    set(guiText.figHandle,'Name','ViRMEn Data');
    set(guiText.sessionTime,'ForegroundColor',[0 0 0],'String','00:45:00');
    set(guiText.sessionTimeText,'ForegroundColor',[0 0 0],'String','Session Time:', 'FontSize', 15);
    set(guiText.timeText,'String','00:00:00');
    set(guiText.trialTextTower,'String','0');
    set(guiText.rewardTextTower,'String','0');
    set(guiText.percCorrTextTower,'String','0%');
    set(guiText.trialTextNoTower,'String','0');
    set(guiText.rewardTextNoTower,'String','0');
    set(guiText.percCorrTextNoTower,'String','0%');

    
    while shouldAcquire
        
        try
            [data] = fread(udpID,15);

            elapTime = char(data(1:8))';
            numTrialsTower = num2str(data(9));
            numRewardsTower = num2str(data(10));
            percCorrectTower = [num2str(data(11)),'%'];
            numTrialsNoTower = num2str(data(12));
            numRewardsNoTower = num2str(data(13));
            percCorrectNoTower = [num2str(data(14)),'%'];
            
            turnOff = data(15);
            
            if turnOff
                stopLiveDataAq();
            end
            
        catch err
            if strcmpi(err.identifier,'MATLAB:badsubscript')
                display('Could not acquire data. Retrying');
            end
            pause(.2);
            continue;
        end
        
        figure(guiText.figHandle)
        set(guiText.timeText,'String',elapTime);
        set(guiText.trialTextTower,'String',numTrialsTower);
        set(guiText.rewardTextTower,'String',numRewardsTower);
        set(guiText.percCorrTextTower,'String',percCorrectTower);
        set(guiText.trialTextNoTower,'String',numTrialsNoTower);
        set(guiText.rewardTextNoTower,'String',numRewardsNoTower);
        set(guiText.percCorrTextNoTower,'String',percCorrectNoTower);
        
        if strcmpi(elapTime,get(guiText.sessionTime,'String'))
            timeOverFlag = true;
            timeOverMark = now;
            set(guiText.sessionTime,'ForegroundColor',[1 0 0]);
            set(guiText.sessionTimeText,'ForegroundColor',[1 0 0],'String','SESSION COMPLETE','FontSize',11);
            set(guiText.figHandle,'Name','ViRMEn Data --- SESSION COMPLETE');
        end
        
        if timeOverFlag
            set(guiText.sessionTime,'String',datestr(now - timeOverMark,'HH:MM:SS'));
            if second(now-timeOverMark) <= 30 && beepFlag
                beep;
            end
        end
        
        pause(.002);
     end
end