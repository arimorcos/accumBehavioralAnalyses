%getUpdatedGUI.m

%function to grab information from text entry boxes in the gui

%ASM 6/15/12

function [winSize checks] = getUpdatedGUI(guiObjects)
    
    winSize = str2double(get(guiObjects.winSize,'String'));
    
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
    
    
end