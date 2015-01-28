function [trialInd,meanVal] = findOppositeViewAngleTrials(dataCell,bin)
%findOppositeViewAngleTrials.m Finds subset of trials with a view angle
%opposite the given trial
%
%INPUTS
%dataCell - dataCell
%bin - Either a bin number or a fraction of total bins
%
%OUPTUTS
%trialInd - array of trial indices which combine to have zero mean for view
%   angle
%
%ASM 11/14

%process bin
if bin < 1
    nBins = size(dataCell{1}.imaging.binnedDataFrames,2);
    bin = round(nBins*bin);
end

%extact dataFrames
data = cellfun(@(x) x.binnedDat,dataCell,'UniformOutput',false);
data = cat(3,data{:});

%limit to bin number and view angle
theta = squeeze(data(4,bin,:));

%convert to degrees
theta = radtodeg(theta-pi/2);

%get left or right trials
leftTrials = getCellVals(dataCell,'maze.leftTrial');

%get whether theta is greater or less than 0 
binaryTheta = theta;
binaryTheta(binaryTheta > 0) = 1;
binaryTheta(binaryTheta < 0) = 0;

%get subset of trials where theta and leftTrials disagree
trialInd = find(leftTrials' & ~binaryTheta);

%get mean theta
meanVal = mean(theta(trialInd));




