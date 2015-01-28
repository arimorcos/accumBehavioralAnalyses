function plotZeroMeanAccuracy(posBins,accuracy,sig,meanTheta,nTrials)
%plotZeroMeanAccuracy.m Plots accuracy in trials where the mean theta is 0 
%
%INPUTS
%accuracy - 1 x nBins array of accuracy
%sig - 1 x nBins logical of significant or not
%meanTheta - 1 x nBins array of meanTheta
%nTrials - 1 x nBins array of nTrials for each bin
%
%ASM 11/14

segRanges = 0:80:480;

%create figure;
figH = figure;

%get subplot positions
xOffset = [0.05 0.05];
yOffset = [0.05 0.05];
plotSpacing = [0.05 0.05];
divSpacing = 0.05;
positions = calcSubplotDivPositions(1,1,3,[0.2,0.2,0.6],1,xOffset,...
    yOffset,plotSpacing,divSpacing);

%create accuracy plot
accAx = subplot('Position',positions(3,:));
accPlot = plot(posBins,accuracy);
accPlot.Color = 'b';
accPlot.LineWidth = 2;
hold on;
newSig = nan(size(sig));
newSig(sig) = 50;
sigPlot = plot(posBins,newSig);
sigPlot.Color = 'k';
sigPlot.LineWidth = 2;
ylim([0 100]);
ylabel('Accuracy','FontSize',20);
accAx.XLim = [min(posBins) max(posBins)];

%add on segment dividers
for segRangeInd = 1:length(segRanges)
    line(repmat(segRanges(segRangeInd),1,2),[0 100],'Color','g',...
        'LineStyle','--','LineWidth',2);
end

%create nTrialsPlot
nTrialAx = subplot('Position',positions(2,:));
nTrialsPlot = plot(posBins,nTrials);
nTrialsPlot.Color = 'r';
nTrialsPlot.LineWidth = 2;
ylabel('# Trials','FontSize',20);
nTrialAx.XLim = [min(posBins) max(posBins)];

%add on segment dividers
for segRangeInd = 1:length(segRanges)
    line(repmat(segRanges(segRangeInd),1,2),[0 max(nTrials)],'Color','g',...
        'LineStyle','--','LineWidth',2);
end

%create meanThetaPlot
meanThetaAx = subplot('Position',positions(1,:));
meanThetaPlot = plot(posBins,meanTheta);
meanThetaPlot.Color = 'm';
meanThetaPlot.LineWidth = 2;
ylabel('Mean View Angle','FontSize',20);
xlabel('Y Position (Binned)','FontSize',20);
meanThetaAx.XLim = [min(posBins) max(posBins)];

%add on segment dividers
for segRangeInd = 1:length(segRanges)
    line(repmat(segRanges(segRangeInd),1,2),[min(meanTheta) max(meanTheta)],'Color','g',...
        'LineStyle','--','LineWidth',2);
end

%link
linkaxes([accAx nTrialAx meanThetaAx],'x');