function [figH] = plotRandSegNoise(mousePerf,simPerf,groupConds,axesHandle)
%plotRandSegNoise.m Plots mouse performance vs. mouse choosing random
%segment with noise subtracted out 
%
%INPUTS
%mousePerf - 1 x nConds array of mouse turns toward left/white
%simPerf - output of calcRandSegPerf (nSim x nConds array)
%groupConds - group equal and opposite conditions (6-0 and 0-6)
%axesHandle - axesHandle to plot on. If empty, will create figure
%
%OUTPUTS
%figH - figure handle
%
%ASM 10/13

%create figure if no axes handle provided
if nargin < 4 || isempty(axesHandle)
    figH = figure;
    axesHandle = axes;
else
    figH = [];
end

%check if groupConds provided
if nargin < 3 || isempty(groupConds)
    groupConds = false;
end

%set current axes to axes handle
axes(axesHandle);

%get mean and 95% confidence intervals for simPerf
meanSimPerf = mean(simPerf);
sortSim = sort(simPerf,1);
simLowerBound = abs(meanSimPerf - sortSim(round(size(simPerf,1)*0.025),:));
simUpperBound = abs(meanSimPerf - sortSim(round(size(simPerf,1)*0.975),:));

%plot
simPlot = errorbar(0:size(simPerf,2)-1,meanSimPerf,simLowerBound,simUpperBound,...
    'bo','MarkerSize',15,'MarkerFaceColor','b','LineWidth',2);
hold on;
mousePlot = scatter(0:size(simPerf,2)-1,mousePerf,'r^','MarkerFaceColor','r',...
    'SizeData',150);

%set limits
ylim([0 100]);
xlim([-0.5 0.5+size(simPerf,2)-1]);

%set xticks
set(axesHandle,'XTick',0:size(simPerf,2)-1);

%make square
axis square;

%labels
if groupConds
    xlabel('Condition','FontSize',25);
    ylabel('Percent Correct','FontSize',25);
    tickHand = genTickHand(size(simPerf,2));
    set(axesHandle,'XTickLabel',tickHand);
else
    xlabel('Number of Left Segments','FontSize',25);
    ylabel('Percent Turns Toward Left','FontSize',25);
end

%change fontsize
set(axesHandle,'FontSize',20);

%create legend
legend({'Simulation','Actual Performance'},'Location','SouthEast');

end

function tickHand = genTickHand(midPoint)

%initialize
tickHand = cell(1,midPoint);

for i = 1:midPoint
    
    tickHand{i} = sprintf('%d-%d',2*midPoint-i-1,i-1);
    
end

end
