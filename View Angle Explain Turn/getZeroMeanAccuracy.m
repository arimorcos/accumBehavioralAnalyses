function [accuracy,sig,meanTheta,nTrials] = getZeroMeanAccuracy(dataCell,alpha)
%getZeroMeanAccuracy.m Plots accuracy for zero mean trial sets
%
%INPUTS
%dataCell
%alpha - criterion for significant
%
%OUTPUTS
%accuracy - 1 x nBins array of accuracy
%sig - 1 x nBins logical of significant or not
%meanTheta - 1 x nBins array of meanTheta
%nTrials - 1 x nBins array of nTrials for each bin
%
%ASM 11/14

if nargin < 2 || isempty(alpha)
    alpha = 0.05;
end

%get nBins
nBins = size(dataCell{1}.binnedDat,2);

%initialize
accuracy = zeros(1,nBins);
sig = false(1,nBins);
meanTheta = zeros(1,nBins);
nTrials = zeros(1,nBins);

%loop through each bin and calculate
for binInd = 1:nBins
    
    %get zero mean trials
    [trialInd,tempTheta] = findZeroMeanViewAngleTrials(dataCell,binInd);
    if isempty(trialInd)
        accuracy(binInd) = NaN;
        meanTheta(binInd) = NaN;
        continue;
    end
    
    %store meanTheta
    meanTheta(binInd) = tempTheta;
    
    
    %get subset
    dataSub = dataCell(trialInd);
    
    %get nTrials
    nTrials(binInd) = length(dataSub);
    
    %get nCorrect
    nCorrect = sum(getCellVals(dataSub,'result.correct'));
    
    %get accuracy 
    accuracy(binInd) = 100*nCorrect/nTrials(binInd);
    
    %find whether significant or not
    pVal = binocdf(nCorrect,nTrials(binInd),0.5,'upper');
    
    %check if significant
    if pVal <= alpha
        sig(binInd) = true;
    end    
end