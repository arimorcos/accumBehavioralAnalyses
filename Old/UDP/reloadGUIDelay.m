%function reloadGUIDelay

%function to reload the GUI for udp for the delay configuration
%ASM 5/2012

function reloadGUIDelay(src,evnt)
    
    global guiText;
    
    if guiText.config == 3
        return;
    end
    
    stopLiveDataAq();
    
    if guiText.config == 1
        delete(guiText.text1,guiText.text2,guiText.text3,guiText.text4,guiText.timeText,guiText.start,...
            guiText.stop,guiText.sessionTime,guiText.trialText,guiText.rewardText,guiText.percCorrText,...
            guiText.sessionTimeText);
    elseif guiText.config == 2
        delete(guiText.text1,guiText.text2,guiText.text3,guiText.text4,guiText.text5,guiText.text6,guiText.text7,...
        guiText.timeText,guiText.trialTextTower,guiText.rewardTextTower,guiText.trialTextNoTower,guiText.rewardTextNoTower,...
        guiText.percCorrTextTower,guiText.percCorrTextNoTower,guiText.start,guiText.stop,guiText.sessionTime,...
        guiText.sessionTimeText);
    end
    
    
    guiText.config = 3;
    
    scrn = get(0,'screensize');
    set(guiText.figHandle,'OuterPosition',[.65*scrn(3) .2*scrn(4) .35*scrn(3) .6*scrn(4)]);

    guiText.text1 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.1 .9 .6 .05],'String','Time Elapsed:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text2 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 1],'Units','Normalized',...
        'Position',[.1 .82 .6 .05],'String','Number of Total Trials:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text3 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.87 0.49 0],'Units','Normalized',...
        'Position',[.1 .74 .6 .05],'String','Number of Total Rewards:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text4 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.23 0.44 .34],'Units','Normalized',...
        'Position',[.1 .66 .6 .05],'String','Total Percent Correct:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text5 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[ 0.49 0.15 0.8],'Units','Normalized',...
        'Position',[.1 .58 .6 .05],'String','Percent Delay:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text6 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.39 0.5 1],'Units','Normalized',...
        'Position',[.1 .5 .65 .05],'String','Number of Delay Condition Trials:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text7 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.55 0.27 .07],'Units','Normalized',...
        'Position',[.1 .42 .6 .05],'String','Number of Delay Condition Rewards:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.text8 = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.55 0.55 .55],'Units','Normalized',...
        'Position',[.1 .34 .6 .05],'String','Percent Correct Delay Condition:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);

    guiText.timeText = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.65 .9 .25 .05],'String','00:00:00','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.trialTextTotal = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 1],'Units','Normalized',...
        'Position',[.7 .82 .2 .05],'String','0','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.rewardTextTotal = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.87 0.49 0],'Units','Normalized',...
        'Position',[.7 .74 .2 .05],'String','0','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.percCorrTextTotal = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.23 0.44 .34],'Units','Normalized',...
        'Position',[.7 .66 .2 .05],'String','0%','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.percDelay = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.49 .15 .8],'Units','Normalized',...
        'Position',[.7 .58 .2 .05],'String','0','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.trialTextDelay = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.39 0.5 1],'Units','Normalized',...
        'Position',[.7 .5 .2 .05],'String','0','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.rewardTextDelay = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.55 0.27 .07],'Units','Normalized',...
        'Position',[.7 .42 .2 .05],'String','0%','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
    guiText.percCorrTextDelay = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0.55 0.55 .55],'Units','Normalized',...
        'Position',[.7 .34 .2 .05],'String','0%','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);

    guiText.start = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.05 .05 .425 .12],'String','Start','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
        'Callback',@startLiveDataAqID3);
    guiText.stop = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.525 .05 .425 .12],'String','Stop','Style','pushbutton','BackgroundColor',[0.7969 0.7969 0.7969],...
        'Callback',@stopLiveDataAq);
    guiText.sessionTime = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.5 .2 .45 .12],'String','00:45:00','Style','edit');
    guiText.sessionTimeText = uicontrol('FontName','Arial','FontSize',15,'FontWeight','bold','ForegroundColor',[0 0 0],'Units','Normalized',...
        'Position',[.05 .2 .4 .1],'String','Session Time:','Style','text','BackgroundColor',[0.7969 0.7969 0.7969]);
end