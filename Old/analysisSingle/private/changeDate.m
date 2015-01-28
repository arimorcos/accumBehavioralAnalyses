%changeDate.m

%function to change file date

function changeDate(src,evnt,guiObjects,dir,numValues,fileList,fileDir)
    oldDate = get(guiObjects.datePopup,'Value');
    if dir && oldDate < numValues
        set(guiObjects.datePopup,'Value',oldDate + 1);
    elseif ~dir && oldDate > 1
        set(guiObjects.datePopup,'Value',oldDate - 1);
    end
    
    newDate(src,evnt,fileList,guiObjects,fileDir);
    
end