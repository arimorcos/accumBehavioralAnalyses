function [errLoc,corrLoc] = getDistractorLocation(dataCell)

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
errLoc = (1-mean(errPatterns))*100;
corrLoc = (1-mean(corrPatterns))*100;