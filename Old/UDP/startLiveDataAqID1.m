%function startLiveDataAqID1.m

%function to start live data acquisition from ViRMen engine on another
%computer

function startLiveDataAqID1(src,evnt)
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
    set(guiText.trialText,'String','0');
    set(guiText.rewardText,'String','0');
    set(guiText.percCorrText,'String','0%');
    
    while shouldAcquire
        
        try
            [data] = fread(udpID,12);
            elapTime = char(data(1:8))';
            numTrials = num2str(data(9));
            numRewards = num2str(data(10));
            percCorrect = [num2str(data(11)),'%'];
            turnOff = data(12);
            
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
        
        elapTime = char(data(1:8))';
        numTrials = num2str(data(9));
        numRewards = num2str(data(10));
        percCorrect = [num2str(data(11)),'%'];
        
        figure(guiText.figHandle)
        set(guiText.timeText,'String',elapTime);
        set(guiText.trialText,'String',numTrials);
        set(guiText.rewardText,'String',numRewards);
        set(guiText.percCorrText,'String',percCorrect);
        
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
        
        pause(.005);
     end
end