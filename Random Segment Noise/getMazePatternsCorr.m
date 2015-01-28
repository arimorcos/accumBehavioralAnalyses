function mazePatternsCorr = getMazePatternsCorr(dataCell)

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%find out if left or white
if isfield(dataCell{1}.maze,'numWhite') %then white
    whiteTrials = getCellVals(dataCell,'maze.whiteTrial');
    %match to maze pattern to get correct turn direciton as 1
    mazePatternsCorr = bsxfun(@eq,mazePatterns,whiteTrials');
elseif isfield(dataCell{1}.maze,'numLeft') %then left/right
    
    %get leftTrials
    leftTrials = getCellVals(dataCell,'maze.leftTrial');
    
    %match to maze pattern to get correct turn direciton as 1
    mazePatternsCorr = bsxfun(@eq,mazePatterns,leftTrials');
else
    error('No integration data found');
end