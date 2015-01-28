function shuffleCallback(src,evnt,results,percCorr)
%callback to create shuffle plot

%open GUI

[shuffleGUI] = shuffleGUI();

%set callback for update button
set(shuffleGUI.plotButton,'Callback',{@updateShufflePlot,shuffleGUI,results,percCorr});

%perform shuffle
[dist] = shuffleTrialLabels(results,nSims);

%plot data
subplot('Position',[0.05 0.15 0.9 0.8]);
cla reset;
plotTrialShuffle(percCorr,dist,alpha);

end