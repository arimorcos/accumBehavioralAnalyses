function [trialInd,meanVal] = findZeroMeanViewAngleTrials(dataCell,bin)
%findZeroMeanViewAngleTrials.m Finds subset of trials with a mean of zero
%view angle at a specified bin
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

criterion = 1;

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

%is mean less than or greater than 0? Extract test values of opposite side
% meanOrigVal = mean(theta);
if dataCell{1}.maze.leftTrial
    meanOrigVal = 1;
else
    meanOrigVal = -1;
end
if sign(meanOrigVal) == 1 %if positive
    testVals = theta(theta < 0); %get negative values
    otherVals = theta(theta > 0);
elseif sign(meanOrigVal) == -1 %if negative
    testVals = theta(theta > 0); %get positive values
    otherVals = theta(theta < 0);
end

%check if more testVals than otherVals
while length(testVals) > length(otherVals)
    [~,maxInd] = max(abs(testVals));
    testVals(maxInd) = [];
end

%get number of testVals
nTestVals = length(testVals);

%loop through each testVal and find similar value (within criterion
%degrees)
sameSignVals = zeros(size(testVals));
minDiff = 0;
for testInd = 1:nTestVals
    
    %subtract all other vals
    difference = abs(testVals(testInd)) - abs(otherVals);
    
    %find minimum difference
    [~,minInd] = min(abs(difference));
    
    %take that value
    sameSignVals(testInd) = otherVals(minInd);
    
    %remove from otherVals
    otherVals(minInd) = [];
    
end

%get allVals
allVals = [sameSignVals;testVals];

%get new meanVal
meanVal = mean(allVals);

%while above criterion
while abs(meanVal) > criterion
    
    %check which way it's off
    if sign(meanVal) == sign(meanOrigVal) %if match
        %remove highest abs(sameSignVal)
        [~,maxInd] = max(abs(sameSignVals));
        sameSignVals(maxInd) = [];
        
        %remove lowest abs(testVal)
        [~,minInd] = min(abs(testVals));
        testVals(minInd) = [];
    else
        %remove highest abs(testVals)
        [~,maxInd] = max(abs(testVals));
        testVals(maxInd) = [];
        
        %remove lowest abs(sameSignVals)
        [~,minInd] = min(abs(sameSignVals));
        sameSignVals(minInd) = [];
    end
    
    %get allVals
    allVals = [sameSignVals;testVals];
    
    %get new meanVal
    meanVal = mean(allVals);
end
% allVals = testVals;
% meanVal = mean(testVals);




%get values
trialInd = find(ismember(theta,allVals));



