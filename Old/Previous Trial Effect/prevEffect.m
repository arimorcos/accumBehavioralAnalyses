%prevEffect.m

%function to open gui and pass data for previous effect plots

%ASM 8/3/12

function prevEffect(src,evnt,data)
    
    %create gui
    [prevGUI] = prevEffectGUI();
    
    %set callbacks
    set(prevGUI.winSize,'Callback',{@updatePrevEffectPlot,prevGUI,data});
    set(prevGUI.plotButton,'Callback',{@updatePrevEffectPlot,prevGUI,data});

end