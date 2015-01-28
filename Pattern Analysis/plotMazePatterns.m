function [handles] = plotMazePatterns(dataCell,figH,axH)
%plotMazePatterns.m Plots maze patterns as heatmap with blue being correct
%direction and red being distractor direction
%
%INPUTS
%dataCell - dataCell to plot maze patterns from 
%figH - figure handle
%axH - axis handle
%
%OUTPUTS
%handles - structure of handles
%
%ASM 6/14

%check for axes inputs
if nargin < 2 || isempty(figH) 
    handles.figH = figure;
    handles.axH = axes;
elseif nargin < 3 || isempty(axH) 
    handles.figH = figH;
    hanldes.axH = axes;
else
    handles.figH = figH;
    handles.axH = axH;
    set(0,'CurrentFigure',figH);
    axes(axH);
end

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%get leftTrials
leftTrials = getCellVals(dataCell,'maze.leftTrial');

%match to maze pattern to get correct turn direciton as 1 
mazePatternsCorr = bsxfun(@eq,mazePatterns,leftTrials');

%sort by 6-0, then 5-1, then 4-2, then 3-3
if isfield(dataCell{1}.maze,'numLeft')
    fieldName = 'numLeft';
else
    fieldName = 'numWhite';
end
nSeg = size(mazePatterns,2);
genPatternID = [1:(nSeg/2)+1 (nSeg/2):-1:1];
presentPatterns = unique(getCellVals(dataCell,['maze.',fieldName]));
possiblePatterns = 0:nSeg;
patternsToTest = unique(genPatternID(ismember(possiblePatterns,presentPatterns)));
mazePatternsSort = [];
for pattInd = patternsToTest
    currNumLeft = possiblePatterns(genPatternID==pattInd);
    findStr = ['maze.',fieldName,'==',num2str(currNumLeft(1))];
    for i = 2:length(currNumLeft)
        findStr = [findStr,',',num2str(currNumLeft(i))]; %#ok<AGROW>
    end
    tempIndices = findTrials(dataCell,findStr);
    tempPatterns = mazePatternsCorr(tempIndices,:);
    [~,~,sortInd] = unique(tempPatterns,'rows');
    tempPatternsSorted = tempPatterns(sort(sortInd),:);
    mazePatternsSort = cat(1,mazePatternsSort,tempPatternsSorted);
end

%plot
imagesc(mazePatternsSort);
colormap(handles.axH,[230/255 9/255 57/255;0 0 1]);
xlabel('Segment #','FontSize',20);
ylabel('Trial #','FontSize',20);



