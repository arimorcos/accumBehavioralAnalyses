function correctProb = distractorGrouping(dataCell)
%finds percentage of correct/error trials with two distractors in first 3,
%second 3, etc.

%exclude non-crutch, non 4-2 trials
dataCell = getTrials(dataCell,'maze.crutchTrial==0;maze.numLeft==2,4');

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%get leftTrials
leftTrials = getCellVals(dataCell,'maze.leftTrial');

%match to maze pattern to get correct turn direciton as 1 
mazePatternsCorr = bsxfun(@eq,mazePatterns,leftTrials');

%find distractor locations
distLocCell = arrayfun(@(x) find(mazePatternsCorr(x,:) == 0),1:size(mazePatternsCorr,1),'UniformOutput',false);
distractorLocations = cat(1,distLocCell{:});

%loop through each set of conditions 
correctProb = zeros(2,4);
locArray = [1 2 3; 2 3 4; 3 4 5; 4 5 6];
for i = 1:4
    
    %find trials which match condition
    match = ismember(distractorLocations,locArray(i,:));
    match = sum(match,2) == 2;
    
    %split into correct and incorrect
    matchTrials = dataCell(match);
    correctProb(1,i) = 100*sum(findTrials(matchTrials,'result.correct==1'))/length(matchTrials);
    
end
for i = 1:4
    
    %find trials which match condition
    match = ismember(distractorLocations,locArray(i,:));
    match = sum(match,2) == 1;
    
    %split into correct and incorrect
    matchTrials = dataCell(match);
    correctProb(2,i) = 100*sum(findTrials(matchTrials,'result.correct==1'))/length(matchTrials);
    
end