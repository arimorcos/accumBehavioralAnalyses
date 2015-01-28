function [handles] = plotSegNetEv(segBreakdown,labels,pooledVals,pSeg,pPool,...
    plottType)
%plotSegNetEv.m Plots segment by net evidence analysis breakdown
%
%INPUTS
%segBreakdown - nSeg x nEvCombinations array containing the probability of
%   each segment at each net evidence value predicting eventual turn 
%labels - 1 x nEvCombinations array containing net evidence values for each
%   label
%pooledVals - 1 x nSeg array containing the probability each segment
%   predicts eventual turn independent of net evidence
%pSeg - one-sided anova p value between segments
%pPool - one-sided anova p value between pools
%plotType - 0 - Only evidence breakdown
%           1 - Only All conditions
%           2 - Both
%
%OUTPUTS
%handles - handles structure 
%
%ASM 10/13 

%create figure
handles.figH = figure('Name','Segment Breakdown by Net Evidence Accumulated');

%get nSeg
nSeg = size(segBreakdown,1);

%create colors array
colors = distinguishable_colors(length(pooledVals));

%create subplot
handles.netEvAx = subplot(1,6,[1 5]);

%turn hold on
hold on;

%initialize plot handles
handles.plots = gobjects(1,nSeg);

%cycle through each segment and plot
for i = 1:nSeg %for each segment
    
    %plot
    xInd = ~isnan(segBreakdown(i,:));
    handles.plots(i) = plot(labels(xInd),segBreakdown(i,xInd),'Color',colors(i,:),...
        'LineWidth',1,'Marker','o','MarkerFaceColor',colors(i,:),...
        'MarkerEdgeColor',colors(i,:),'MarkerSize',12,'LineStyle','-');
    
end

%display pVal 
handles.pSegText = text(0,0.05,sprintf('p = %.4f',pSeg),...
    'FontWeight','Bold','HorizontalAlignment','Center');

%label axes
handles.yLabel = ylabel('Probability Segment Predicts Turn');
handles.xLabel = xlabel('Net Evidence Accumulated');

%set limits
ylim([0 1]);

%set xTick
set(handles.netEvAx,'XTick',labels);

%create legend
legEnt = cellfun(@(x) sprintf('Segment %d',x),...
    num2cell(1:nSeg),'UniformOutput',false);
handles.leg = legend(legEnt,'Location','SouthEast');


%PLOT POOLEDVALS

%create axes
handles.pooledAx = subplot(1,6,6);

%plot 
handles.pooledPlot = scatter(0.01*randi([50,150],1,length(pooledVals)),...
    pooledVals,120,colors,'filled');

%display pVal 
handles.pPoolText = text(1,0.05,sprintf('p = %.4f',pPool),...
    'FontWeight','Bold','HorizontalAlignment','Center');

%set lims
ylim([0 1]);
xlim([0.5 1.5]);

%set xtick label
set(handles.pooledAx,'XTick',1,'XTickLabel','All Conditions');