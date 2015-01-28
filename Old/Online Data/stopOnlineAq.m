%stopOnlineAq.m

%function to stop online acquisition by changing the value of the global
%shouldOnline. Called by the stop button in gui. 

%ASM 6/13/12

function stopOnlineAq(src,evnt,guiObjects)
    global shouldOnline;
    
    shouldOnline = false;
    
    set(guiObjects.start,'String','Start','ForegroundColor',[0 0 0]);
end