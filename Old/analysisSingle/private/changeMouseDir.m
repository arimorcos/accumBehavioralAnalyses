%changeMouseDir.m

%function to change between archived and current mice

function changeMouseDir(src,evnt,guiObjects)
    
    global paths;
    
    paths.whichPath = get(guiObjects.mouseToggle,'Value');
    
    if ~paths.whichPath
        set(guiObjects.mouseToggle,'String','Current');
        origDir = cd(paths.currPath);
    else
        set(guiObjects.mouseToggle,'String','Archived');
        origDir = cd(paths.archPath);
    end
    folderList = dir('AM*'); 
    
    %set up animal change section 
    anNames = arrayfun(@(x) x.name,folderList,'UniformOutput',false);
    anNames =  cellfun(@(x)[x,'|'],anNames,'UniformOutput',false);
    anNames = strcat(anNames{:});
    anNames = anNames(1:end-1);
    
    %update callbacks
    set(guiObjects.animalButtonRight,'Callback',{@changeAnimal,guiObjects,1,length(folderList),folderList});
    set(guiObjects.animalButtonLeft,'Callback',{@changeAnimal,guiObjects,0,length(folderList),folderList});
    set(guiObjects.animalPopup,'Callback',{@newAnimal,guiObjects,folderList});

    set(guiObjects.animalPopup,'String',anNames,'Value',length(folderList));
    newAnimal(src,evnt,guiObjects,folderList);
    cd(origDir);
end