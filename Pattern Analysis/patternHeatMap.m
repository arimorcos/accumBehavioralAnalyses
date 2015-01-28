function figH = patternHeatMap(dataCell)
%patternHeatMap.m Analyzes 4-2 trials to create a heatmap showing percent
%correct for each pattern
%
%INPUTS
%dataCell - dataCell containing integration data
%
%OUTPUTS
%figH - figure handle
%
%ASM 7/14

%exclude non-crutch, non 4-2 trials
if isfield(dataCell{1}.maze,'numLeft')
    dataCell = getTrials(dataCell,'maze.crutchTrial==0;maze.numLeft==2,4');
else
    dataCell = getTrials(dataCell,'maze.crutchTrial==0;maze.numWhite==2,4');
end

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%get leftTrials
if isfield(dataCell{1}.maze,'numLeft')
    leftTrials = getCellVals(dataCell,'maze.leftTrial');
else
    leftTrials = getCellVals(dataCell,'maze.whiteTrial');
end

%match to maze pattern to get correct turn direciton as 1
mazePatternsCorr = bsxfun(@eq,mazePatterns,leftTrials');

%find distractor locations
distLocCell = arrayfun(@(x) find(mazePatternsCorr(x,:) == 0),1:size(mazePatternsCorr,1),'UniformOutput',false);
distractorLocations = cat(1,distLocCell{:});

%get unique distractor location patterns
allPatternTypes = unique(distractorLocations,'rows');
patternAccuracy = nan(6,6);

%loop through each pattern and get percent correct
for patternInd = 1:size(allPatternTypes,1)
    
    %get current pattern
    currPatt = allPatternTypes(patternInd,:);
    
    %find trials which match pattern
    pattMatch = ismember(distractorLocations,currPatt,'rows');
    
    %get trials which match
    pattDataCell = dataCell(pattMatch);
    
    %get percent correct
    patternAccuracy(currPatt(1),currPatt(2)) = 100*sum(findTrials(pattDataCell,'result.correct==1'))/length(pattDataCell);
end

%create figure
figH = figure('Name',sprintf('Pattern Heat Map -- Mouse %d -- Date %s',...
    dataCell{1}.info.mouse,dataCell{1}.info.date));
imagesc(patternAccuracy,[0 100]);
axis square;
xlabel('Second Minority Cue Location','FontSize',30);
ylabel('First Minority Cue Location','FontSize',30);
set(gca,'FontSize',20)
currMap = colormap;
currMap(1,:) = [1 1 1];
colormap(currMap);
cBar = colorbar;
set(get(cBar,'Label'),'string','Percent Correct','FontSize',30);
set(cBar,'FontSize',20);