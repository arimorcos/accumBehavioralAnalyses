function viewCorr = getPairwiseViewAngleCorrelation(dataCell)
%getPairwiseViewAngleCorrelation.m Calculates the pairwise view angle
%correlation for each pair of trials 
%
%INPUTS
%dataCell 
%
%OUTPUTS
%viewCorr - nTrials x nTrials correlation matrix
%
%ASM 4/15

%extract binned dataFrames 
binnedDF = catBinnedDataFrames(dataCell);

%extract viewAngle as nTrials x nBins 
viewAngle = squeeze(binnedDF(4,:,:))';
viewAngle = viewAngle(:,2:end-1);

%calculate the correlation
viewCorr = 1 - squareform(pdist(viewAngle,'correlation'));