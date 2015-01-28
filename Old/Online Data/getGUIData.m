%getGUIData.m

%function to grab information from text entry boxes in the gui

%ASM 6/15/12

function [winSize lastX sessionTimeVector oldWinSize reCalcWinFlag checks pause] = getGUIData(guiObjects, oldWinSize)
    
    winSize = str2double(get(guiObjects.winSize,'String'));
    if oldWinSize ~= winSize
        reCalcWinFlag = true;
    else
        reCalcWinFlag = false;
    end
    oldWinSize = winSize;

    lastX = str2double(get(guiObjects.lastX,'String'));
    
    sessionTimeVector = rem(datenum(get(guiObjects.sessionTime,'String')),1);
    
    %check checkbox states
    if (get(guiObjects.leftCheck,'Value') == get(guiObjects.leftCheck,'Max'))
        checks.leftCheck = true;
    else
        checks.leftCheck = false;
    end
    
    if (get(guiObjects.trialCheck,'Value') == get(guiObjects.trialCheck,'Max'))
        checks.trialCheck = true;
    else
        checks.trialCheck = false;
    end
    
    if (get(guiObjects.whiteCheck,'Value') == get(guiObjects.whiteCheck,'Max'))
        checks.whiteCheck = true;
    else
        checks.whiteCheck = false;
    end
    
    if (get(guiObjects.percCorrCheck,'Value') == get(guiObjects.percCorrCheck,'Max'))
        checks.percCorrCheck = true;
    else
        checks.percCorrCheck = false;
    end
    
    if (get(guiObjects.legendCheck,'Value') == get(guiObjects.legendCheck,'Max'))
        checks.legendCheck = true;
    else
        checks.legendCheck = false;
    end
    
    %get pause button
    pause = get(guiObjects.pause,'Value');
    
end