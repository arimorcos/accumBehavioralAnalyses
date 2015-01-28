function turnAroundTrials = findTurnAroundTrials(dataCell,range)
%findTurnAroundTrials.m Function which finds trials in which the mouse
%turned around while running the maze
%
%INPUTS
%dataCell - dataCell array of trial data
%range - 1 x 2 array of min and max fraction of total length in which a
%   turn counts. If empty defaults to [0.1 0.9]
%
%OUPTUS
%turnAroundTrials - nTrials x 1 logical of whether each trial contained a
%   turn around
%
%ASM 11/13

if nargin < 2 || isempty(range)
    range = [0.1 0.9];
end

%get all dat
allData = getCellVals(dataCell,'dat');

%get total maze length
maxYPos = max(allData(3,:));
minYPos = min(allData(3,:));
mazeLength = maxYPos - minYPos;

%get maze range
minRange = range(1)*mazeLength + minYPos;
maxRange = range(2)*mazeLength + minYPos;

%initialize
nTrials = length(dataCell);
turnAroundTrials = false(nTrials,1);

%cycle through each trial
for i = 1:nTrials %for each trial
    
    %get data
    data = dataCell{i}.dat;
    
    %subset based on range
    theta = data(4,find(data(3,:) >= minRange,1,'first'):find(data(3,:) <= ...
        maxRange,1,'last'));
    
    %normalize theta
    theta = mod(theta,2*pi);
    
    %check if turn around (theta ever > pi or < 0 )
    if any(theta > pi | theta < 0) 
        turnAroundTrials(i) = true;
    end
    
end
    
    
