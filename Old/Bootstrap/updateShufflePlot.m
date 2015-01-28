function updateShufflePlot(src,evnt,shuffleGUIData,results,percCorr,arrow)
    
    nSims = str2double(get(shuffleGUIData.nSims,'String'));
    alpha = str2double(get(shuffleGUIData.alpha,'String'));
    bias = get(shuffleGUIData.bias,'Value');

    %perform shuffle
    [dist] = shuffleTrialLabels(results,nSims,bias);

    %plot data
    subplot('Position',[0.05 0.15 0.9 0.8]);
    cla reset;
    delete(arrow);
    [arrow] = plotTrialShuffle(percCorr,dist,alpha);
    
    %reset callback
    set(shuffleGUIData.plotButton,'Callback',{@updateShufflePlot,shuffleGUIData,results,percCorr,arrow});

end

