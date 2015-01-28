function delibTrials = findDeliberationTrials(dataCell,thresh)
%findDeliberationTrials.m Function to search through dataCell (with data
%appended as field) and find trials in which the mouse deliberated by going
%into the other arm first 
%
%INPUTS
%dataCell - cell array of structures containing trial information, must
%   include data array as field
%thresh - fraction between 0 and 1 indicating how far into the other arm
%   mouse must have gone to count as deliberation trial
%
%OUTPUTS
%delibTrials = nTrials x 1 logical of which trials are deliberation trials
%
%ASM 11/13

%get left turns
leftTurns = getCellVals(dataCell,'result.leftTurn');

%get maximum absolute x value from each trial
maxAbsX = mean(cellfun(@(x) max(abs(x.dat(2,:))),dataCell));

%get max and min x value from each trial
maxX = cellfun(@(x) max(x.dat(2,:)),dataCell);
minX = cellfun(@(x) min(x.dat(2,:)),dataCell);

%calc delibThresh
delibThresh = thresh*maxAbsX;

%create maxOther and set values
maxOtherArray = zeros(length(dataCell),1);
maxOtherArray(leftTurns) = maxX(leftTurns);
maxOtherArray(~leftTurns) = minX(~leftTurns);

%find trials where max other > delibThresh
delibTrials = abs(maxOtherArray) >= delibThresh;
