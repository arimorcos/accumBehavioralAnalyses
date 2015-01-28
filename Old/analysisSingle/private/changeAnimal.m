%changeAnimal.m

%function to change animal

function changeAnimal(src,evnt,guiObjects,dir,numAnimals,folderList)
    
    oldAnimal = get(guiObjects.animalPopup,'Value');
    if dir && oldAnimal < numAnimals
        set(guiObjects.animalPopup,'Value',oldAnimal + 1);
    elseif ~dir && oldAnimal > 1
        set(guiObjects.animalPopup,'Value',oldAnimal - 1);
    end
    
    newAnimal(src,evnt,guiObjects,folderList);
    
end