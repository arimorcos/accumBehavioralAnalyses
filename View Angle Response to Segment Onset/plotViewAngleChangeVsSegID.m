function plotViewAngleChangeVsSegID(dataCell,deltaView)
%plotViewAngleChangeVsSegID.m Plots change in view angle vs the segment
%identity for each segment
%
%INPUTS
%dataCell 
%deltaView - nTrials x nSeg array of changes in view angle
%
%ASM 11/14

%create figure
figH = figure;

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%hold on
axH = axes;
hold on;

%get nSeg
nSeg = size(mazePatterns,2);

%create colors
colors = jet(nSeg);
segLabels = {};

%loop through each segment
for segInd = 1:nSeg
    
    %get left and right vals
    leftVals = deltaView(logical(mazePatterns(:,segInd)),segInd);
    rightVals = deltaView(~logical(mazePatterns(:,segInd)),segInd);
    
    %plot
    jitter = randn(1,2)/10;
    ePlot = errorbar((1:2)+jitter,[mean(rightVals),mean(leftVals)],...
        [std(rightVals),std(leftVals)]);
    ePlot.Color = colors(segInd,:);
    ePlot.LineWidth = 2;
    ePlot.Marker = 'o';
    ePlot.MarkerSize = 15;
    ePlot.MarkerFaceColor = colors(segInd,:);
    
    %create segLabel
    segLabels = cat(1,segLabels{:},{sprintf('Segment #%d',segInd)});
end
axH.XTick = [1 2];
axH.XTickLabel = {'Right Segments','Left Segments'};
legend(segLabels,'Location','Best','FontSize',20);
