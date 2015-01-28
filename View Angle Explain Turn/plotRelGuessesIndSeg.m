function plotRelGuessesIndSeg(classifierOut)
%plotRelGuessesIndSeg.m Plots the normalized guesses for each segment
%
%INPUTS
%classifierOut
%
%ASM 11/14

%retrieve from classifierOut
accuracy = classifierOut(1).accuracy;
classGuess = classifierOut(1).classGuess;

%get nBinsPerSeg and nSeg
[nSeg,nBinsPerSeg] = size(accuracy);

%create figure
figH = figure;
axH = axes;
hold on;

colors = jet(6);

segLabels = {};

%loop through each segment
for segInd = 1:nSeg
    
    %get segSub
    tempSub = classGuess(:,round(nBinsPerSeg/2),segInd);
   
    %find mode
    modeVal = mode(tempSub);
    
    %find unique vals
    uniqueVals = unique(tempSub);
    
    %loop through each unique val nd find relative expression
    relExp = zeros(1,length(uniqueVals));
    for valInd = 1:length(uniqueVals)
        relExp(valInd) = sum(tempSub==uniqueVals(valInd))/sum(tempSub==modeVal);
    end
    
    %plot
    plotH = plot(uniqueVals,relExp);
    plotH.Color = colors(segInd,:);  
    plotH.LineWidth = 2;
    plotH.Marker = 'o';
    plotH.MarkerFaceColor = colors(segInd,:);
    
    %create segLabel
    segLabels = cat(1,segLabels{:},{sprintf('Segment #%d',segInd)});
    
end

axH.FontSize = 20;
axH.XLabel.String = 'Net Evidence';
axH.YLabel.String = 'Relative Guesses';

legend(segLabels,'Location','BestOutside','FontSize',20);