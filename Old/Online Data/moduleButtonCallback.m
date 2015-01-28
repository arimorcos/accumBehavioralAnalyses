function [] = moduleButtonCallback(src,evnt,guiObjects,data,exper,procData)
%MODULEBUTTONCALLBACK Function to get callback value and open module

%get value from listbox 
listVal = get(guiObjects.moduleList,'Value');
modStrings = get(guiObjects.moduleList,'String');

selectedModule = modStrings{listVal};

switch upper(selectedModule)
    case 'SIGNIFICANCE'
        shuffleFunction(procData.results,procData.fracCorr);
    case 'RUN SPEED'
        runFunction(data,exper);
    case 'PREVIOUS TRIAL EFFECT'
        prevEffectFunction(procData);
    otherwise
        error('Strings do not match. Check switch case.');
end

end

