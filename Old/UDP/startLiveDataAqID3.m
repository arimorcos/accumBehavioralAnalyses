%function startLiveDataAqID3.m

%function to start live data acquisition from ViRMen engine on another
%computer

function startLiveDataAqID3(src,evnt)
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
    set(guiText.trialTextTotal,'String','0');
    set(guiText.rewardTextTotal,'String','0');
    set(guiText.percCorrTextTotal,'String','0%');
    set(guiText.percDelay,'String','0%');
    set(guiText.trialTextDelay,'String','0');
    set(guiText.rewardTextDelay,'String','0');
    set(guiText.percCorrTextDelay,'String','0%');

    
    while shouldAcquire
        
        try
            [data] = fread(udpID,16);

            elapTime = char(data(1:8))';
            numTrialsTotal = num2str(data(9));
            numRewardsTotal = num2str(data(10));
            percCorrectTotal = [num2str(data(11)),'%'];
            percDelay = [num2str(data(12)),'%'];
            numTrialsDelay = num2str(data(13));
            numRewardsDelay = num2str(data(14));
            percCorrectDelay = [num2str(data(15)),'%'];
            
            turnOff = data(16);
            
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
        set(guiText.trialTextTotal,'String',numTrialsTotal);
        set(guiText.rewardTextTotal,'String',numRewardsTotal);
        set(guiText.percCorrTextTotal,'String',percCorrectTotal);
        set(guiText.percDelay,'String',percDelay);
        set(guiText.trialTextDelay,'String',numTrialsDelay);
        set(guiText.rewardTextDelay,'String',numRewardsDelay);
        set(guiText.percCorrTextDelay,'String',percCorrectDelay);
        
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