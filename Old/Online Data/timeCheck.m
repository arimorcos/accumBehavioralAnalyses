%timeCheck.m

%function to check whether time has elapsed

%ASM 6/15/12

function timeCheck(guiObjects,elapTime,sessionTime,titleString)
    
    if elapTime >= sessionTime
        set(guiObjects.figHandle,'Name',[titleString,' --- TIME HAS ELAPSED']);
        set(guiObjects.sessionTime,'ForegroundColor',[1 0 0]);
        set(guiObjects.sessionText,'ForegroundColor',[1 0 0],'String','SESSION COMPLETE','FontSize',13);
    else
        set(guiObjects.figHandle,'Name',titleString);
        set(guiObjects.sessionText,'String','Session Time: ','ForegroundColor',[0 0 0],'FontSize',15);
        set(guiObjects.sessionTime,'ForegroundColor',[0 0 0]);
    end

end