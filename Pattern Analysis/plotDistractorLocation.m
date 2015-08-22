function [handles] = plotDistractorLocation(dataCell,figH,axH)
%plotDistractorLocation.m Plots percentage of trials with distractor at
%each segment location for correct and incorrect trials
%
%INPUTS
%dataCell - dataCell to plot maze patterns from 
%
%OUTPUTS
%handles - structure of handles
%
%ASM 6/14

if nargin < 2 || isempty(figH) 
    %check for axes inputs
    handles.figH = figure('Name',sprintf('Correct Vs. Error Distractor Locations -- Mouse %d -- Date %s',...
        dataCell{1}.info.mouse,dataCell{1}.info.date));
    handles.axH = axes;
elseif nargin < 3 || isempty(axH)
    handles.figH = figH;
    handles.axH = axes;
else
    handles.figH = figH;
    handles.axH = axH;
    set(0,'CurrentFigure',figH);
    axes(axH);
end

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%get leftTrials
if isfield(dataCell{1}.maze,'numLeft') %if fixed
    leftTrials = getCellVals(dataCell,'maze.leftTrial');
    %match to maze pattern to get correct turn direciton as 1
    mazePatternsCorr = bsxfun(@eq,mazePatterns,leftTrials');
elseif isfield(dataCell{1}.maze,'numWhite') %if dms
    whiteTrials = getCellVals(dataCell,'maze.whiteTrial');
    %match to maze pattern to get correct turn direciton as 1
    mazePatternsCorr = bsxfun(@eq,mazePatterns,whiteTrials');
else
    error('Cannot read maze data');
end

%split into correct and incorrect
corrPatterns = mazePatternsCorr(findTrials(dataCell,'result.correct==1;maze.crutchTrial==0'),:);
errPatterns = mazePatternsCorr(findTrials(dataCell,'result.correct==0;maze.crutchTrial==0'),:);

%get fraction of trials with distractor at location
errLocations = (1-mean(errPatterns))*100;
corrLocations = (1-mean(corrPatterns))*100;

%plot
handles.corrPlot = plot(1:length(corrLocations),corrLocations,'b-o','MarkerSize',20,'MarkerFaceColor','b','LineWidth',2);
hold on;
handles.errPlot = plot(1:length(corrLocations),errLocations,'r-x','MarkerSize',20,'LineWidth',2);
legend([handles.corrPlot(1),handles.errPlot(1)],{'Correct Trials','Error Trials'},'Location','NorthEast');
set(gca,'XTick',1:length(corrLocations));
xlabel('Segment #','FontSize',30);
xlim([0.5 length(corrLocations)+.5]);
ylabel('Percent Trials with Minority Segment Present','FontSize',30);
set(gca,'FontSize',20);
axis square;