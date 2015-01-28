function figH = plotDeliberationData(delibFreq,delibPerf,nonDelibPerf,...
    subsets,mouse,nTrials)
%plotDeliberationData.m Plots deliberaiton data
%
%INPUTS
%delibFreq - frequency of deliberations in each subset
%delibPerf - performance on deliberation tirals in each subset
%nonDelibPerf - performance on non-deliberation trials in each subset
%subsets - names of subsets
%mouse - mouse name 
%nTrials - number of trials
%
%ASM 11/13

%get nSubs
nSubs = length(subsets);

%create figure
figH = figure;

%create frequency subplot
freqAx = subplot(1,2,1);
freqPlot = bar(100*delibFreq);
ylim([0 100]);
title('Frequency of deliberations', 'FontSize',20);
ylabel('Percent deliberation trials', 'FontSize',20);
set(freqAx,'XTickLabel',subsets,'FontSize',15);
rotateXLabels(freqAx,45);

%create deliberation performance plot
delibPerfAx = subplot(1,2,2);
delibPerfPlot = bar([delibPerf;nonDelibPerf]');
ylim([0 100]);
title('Performance on deliberation trials', 'FontSize',20);
ylabel('Percent correct', 'FontSize',20);
set(delibPerfAx,'XTickLabel',subsets,'FontSize',15);
rotateXLabels(delibPerfAx,45);
legend({'Deliberation Trials','Non-Deliberation Trials'},'Location','NorthEast');

%create title and xlabel
[~,xLabHand] = suplabel('Data Subset','x');
[~,titleHand] = suplabel(sprintf('Deliberation data for mouse %s nTrials = %d',mouse,nTrials),'t');
set([xLabHand, titleHand], 'FontSize',25);
