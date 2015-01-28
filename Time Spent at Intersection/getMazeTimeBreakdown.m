function [tInfo] = getMazeTimeBreakdown(dataCell,thresh)
%getMazeTimeBreakdown.m Calculates mean time spent in stem and in
%intersection
%
%INPUTS
%dataCell - dataCell containing dat field
%thresh - number between 0 and 1 signifying maze length threshold
%
%OUTPUTS
%tInfo - structure of outputs
%
%ASM 1/14

%get maze length
mazeLength = max(dataCell{1}.dat(3,:));

%calculate threshold
mThresh = thresh*mazeLength;

%get nTrials
nTrials = length(dataCell);

%initialize arrays
tInfo.stemTimes = zeros(1,nTrials);
tInfo.tTimes = zeros(1,nTrials);

%loop through each trial and get times
for i = 1:nTrials
    
    %get first index past thresh
    threshInd = find(dataCell{i}.dat(3,:) >= mThresh,1,'first');
%     lowInd = find(dataCell{i}.dat(3,:) >= 0.15*mazeLength,1,'first');
    
    %calculate time in stem
    stemDNum = dataCell{i}.dat(1,threshInd) - dataCell{i}.dat(1,1);
    tDNum = dataCell{i}.dat(1,end) - dataCell{i}.dat(1,threshInd+1);
    
    %convert times to seconds
    tInfo.stemTimes(i) = dnum2secs(stemDNum);
    tInfo.tTimes(i) = dnum2secs(tDNum);
    
end