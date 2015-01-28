function figH = plotViewAngelChangeVsSegment(dataCell,figH,axH,colorToPlot,markerToPlot)
%plotViewAngelChangeVsSegment.m Plots change in view angle vs. segment
%number
%
%INPUTS
%dataCell - dataCell containing integration info
%figH - figure handle
%axH - axes handle
%colorToPlot - color to plot in
%markerToPlot - which marker to use
%
%OUTPUTS
%figH - figure handle
%
%ASM 7/14

if nargin < 5 || isempty(markerToPlot)
    markerToPlot = 'o';
end
if nargin < 4 || isempty(colorToPlot)
    colorToPlot = 'b';
end
if nargin < 2 || isempty(figH) 
    figH = figure;
    axH = axes;
elseif nargin < 3 || isempty(axH) 
    axH = axes;
else
    set(0,'CurrentFigure',figH);
    axes(axH);
end

%eliminate crutch trials
dataCell = getTrials(dataCell,'maze.crutchTrial==0');

%eliminate turnaround trials
dataCell = dataCell(~findTurnAroundTrials(dataCell));

%get view angle info
[deltaView] = findViewAngleChange(dataCell);

%get nSeg
nSeg = size(deltaView,2);

%take abs of deltaView
deltaView = abs(deltaView);
    
xVals = (1:nSeg) + 0.1*randn(1,nSeg);
%plot
errorbar(xVals,mean(deltaView),std(deltaView),'Marker',markerToPlot,...
    'LineStyle','-','Color',colorToPlot,'MarkerSize',15,'MarkerFaceColor',...
    colorToPlot,'MarkerEdgeColor',colorToPlot,'LineWidth',2);
xlabel('Segment Number','FontSize',30);
ylabel('Change in View Angle','FontSize',30);
set(axH,'FontSize',20);
xlim([0.5 nSeg+0.5]);
