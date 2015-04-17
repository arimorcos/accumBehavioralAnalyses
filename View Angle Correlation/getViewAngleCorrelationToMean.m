function viewCorr = getViewAngleCorrelationToMean(dataCell)
%getViewAngleCorrelationToMean.m Calculates the view angle on a given trial
%to the mean view angle trace
%
%INPUTS
%dataCell 
%
%OUTPUTS
%viewCorr - nTrials x 1 correlation array
%
%ASM 4/15

%extract binned dataFrames 
binnedDF = catBinnedDataFrames(dataCell);

%extract viewAngle as nTrials x nBins 
viewAngle = squeeze(binnedDF(4,:,:))';

%get yPosBins
yPosBins = dataCell{1}.imaging.yPosBins;
thresh = [0 500];

%crop first 2 and last 2 bins 
keepInd = yPosBins >= thresh(1) & yPosBins <= thresh(2);
viewAngle = viewAngle(:,keepInd);

%get the mean trace 
meanViewAngle = nanmean(viewAngle);

%calculate the correlation
viewCorr = nan(length(dataCell),1);
for trialInd = 1:length(dataCell)
    tempCorr = corrcoef(meanViewAngle,viewAngle(trialInd,:));
    viewCorr(trialInd) = tempCorr(2,1);
end