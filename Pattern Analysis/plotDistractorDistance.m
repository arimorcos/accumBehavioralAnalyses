function [handles,pVal] = plotDistractorDistance(dataCell,figH,axH,colorToPlot,performShuffle)
%plotDistractorDistance.m Plots distance between distractors in 4-2 trials
%vs. performance
%
%INPUTS
%dataCell - dataCell containing integration data
%
%OUTPUTS
%figH - figure handle
%
%ASM 6/14

if nargin < 5 || isempty(performShuffle)
    performShuffle = true;
end
if nargin < 4 || isempty(colorToPlot)
    colorToPlot = 'b';
end
if nargin < 2 || isempty(figH) 
    %check for axes inputs
    handles.figH = figure('Name',sprintf('Distance between Segments vs. Performance -- Mouse %d -- Date %s',...
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

if isfield(dataCell{1}.maze,'numLeft') %if fixed
    %exclude non-crutch, non 4-2 trials
    dataCell = getTrials(dataCell,'maze.crutchTrial==0;maze.numLeft==2,4');
    turnTrials = getCellVals(dataCell,'maze.leftTrial');
elseif isfield(dataCell{1}.maze,'numWhite') %if dms
    %exclude non-crutch, non 4-2 trials
    dataCell = getTrials(dataCell,'maze.crutchTrial==0;maze.numWhite==2,4');
    turnTrials = getCellVals(dataCell,'maze.whiteTrial');
else
    error('Cannot read maze data');
end

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%match to maze pattern to get correct turn direciton as 1
mazePatternsCorr = bsxfun(@eq,mazePatterns,turnTrials');

%find distractor locations
distLocCell = arrayfun(@(x) find(mazePatternsCorr(x,:) == 0),1:size(mazePatternsCorr,1),'UniformOutput',false);
distractorLocations = cat(1,distLocCell{:});

%find distance between distractors
distractorDistances = abs(distractorLocations(:,2) - distractorLocations(:,1));
possDistances = unique(distractorDistances) - 1;

[slope,possDistances,distPerf] = calculateDistractorDistanceInfo(dataCell,...
    distractorDistances,possDistances,false);

if performShuffle
    nShuffles = 500;
    shuffleSlope = zeros(1,nShuffles);
    for shuffleInd = 1:nShuffles
        shuffleSlope(shuffleInd) = calculateDistractorDistanceInfo(dataCell,...
            distractorDistances,possDistances,true);
        dispProgress('Shuffle Ind %d/%d',shuffleInd,shuffleInd,nShuffles);
    end
    
    %find significance
    shuffleSlope = sort(shuffleSlope);
    leastGreaterInd = find(slope > shuffleSlope,1,'last');
    pVal = 1 - leastGreaterInd/nShuffles;
end

%plot
handles.distractorDistPlot = plot(possDistances,distPerf,'o-',...
    'MarkerEdgeColor',colorToPlot,'MarkerFaceColor',colorToPlot,'LineWidth',...
    2,'MarkerSize',15,'Color',colorToPlot);
hold on;
handles.meanPerfLine = line([min(possDistances)-5 max(possDistances)+5],...
    [mean(distPerf) mean(distPerf)],'Color',colorToPlot,'LineStyle','--','LineWidth',2);
set(handles.axH,'xtick',possDistances);
xlim([min(possDistances)-0.5 max(possDistances)+0.5]);
ylim([0 100]);
xlabel('Number of segments between minority cues','FontSize',30);
ylabel('Percent Correct','FontSize',30);
set(handles.axH,'FontSize',20);

end

function [slope,possDistances,distPerf] = calculateDistractorDistanceInfo(dataCell,...
    distractorDistances,possDistances,shouldShuffle)

if shouldShuffle %if should shuffle
    newOrder = randsample(size(distractorDistances,1),size(distractorDistances,1));
    distractorDistances = distractorDistances(newOrder);
end

%calculate performance for each distance
distPerf = zeros(size(possDistances));
for distInd = (possDistances+1)'
    %subset dataCell
    dataSub = dataCell(distractorDistances == distInd);
    
    %calculate performance
    distPerf(distInd) = 100*sum(findTrials(dataSub,'result.correct==1'))/length(dataSub);
    
end

%calculate slope 
coeffs = polyfit(possDistances,distPerf,1);
slope = coeffs(1);

end