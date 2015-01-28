function shuffleFunction(results,percCorr)
%callback to create shuffle plot

%open GUI
[shuffleGUIData] = shuffleGUI();

nSims = str2double(get(shuffleGUIData.nSims,'String'));
alpha = str2double(get(shuffleGUIData.alpha,'String'));
bias = get(shuffleGUIData.bias,'Value');

%perform shuffle
[dist] = shuffleTrialLabels(results,nSims,bias);

%plot data
subplot('Position',[0.05 0.15 0.9 0.8]);
cla reset;
[arrow] = plotTrialShuffle(percCorr,dist,alpha);

%set callback for update button
set(shuffleGUIData.plotButton,'Callback',{@updateShufflePlot,shuffleGUIData,results,percCorr,arrow});

end