function [deltaView,segView,segXPos] = findViewAngleChange(dataCell,segmentOnset,segmentOffset)
%findViewAngleChange.m Finds the view angle change for every trial in
%dataCell in response to each segment
%
%INPUTS
%dataCell - dataCell containing integration data
%segmentOnset - 1 x nSeg array of onsets in y position
%segmentOffset - 1 x nSeg array of offsets in y position
%
%OUTPUTS
%deltaView - nTrials x nSeg array of change in view angle for every trial
%segView - view angle at segment offset
%
%ASM 7/14

if nargin < 3 || isempty(segmentOffset)
    segmentOffset = [79 159 239 319 399 479];
end
if nargin < 2 || isempty(segmentOnset)
    segmentOnset = [0:80:400];
end

%ignore non-crutch trials
dataCell = getTrials(dataCell,'maze.crutchTrial==0');

%get number of trials
nTrials = length(dataCell);

%get nSeg
nSeg = length(segmentOnset);

%initialize output
deltaView = zeros(nTrials,nSeg);
segView = zeros(nTrials,nSeg);
segXPos = zeros(nTrials,nSeg);

%loop through each trial
for trialInd = 1:nTrials
    
    %extract data trace
    yPos = dataCell{trialInd}.dat(3,:);
    theta = dataCell{trialInd}.dat(4,:);
    xPos = dataCell{trialInd}.dat(2,:);
    
    for segInd = 1:nSeg %for each segment
        initialTheta = theta(find(yPos < segmentOnset(segInd),1,'last'));
        endTheta = theta(find(yPos < segmentOffset(segInd),1,'last'));
        deltaView(trialInd,segInd) = rad2deg(endTheta - initialTheta);
        segView(trialInd,segInd) = rad2deg(endTheta - pi/2);
        segXPos(trialInd,segInd) = xPos(find(xPos < segmentOffset(segInd),1,'last'));
    end
%     dispProgress('Trial %d/%d',trialInd,trialInd,nTrials);
end
    