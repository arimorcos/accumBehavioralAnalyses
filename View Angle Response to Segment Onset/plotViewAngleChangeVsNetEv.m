function figH = plotViewAngleChangeVsNetEv(dataCell,figH,axH,colorToPlot,markerToPlot)
%plotViewAngleChangeVsNetEv.m plots net evidence vs. view angle change at segment offset 
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

%get net evidence
netEv = getNetEvidence(dataCell);

%get nSeg
nSeg = size(deltaView,2);

%loop through each condition and get average view angle
netEvConds = -6:6;
netEvThetaMean = zeros(1,length(netEvConds));
netEvThetaSTD = zeros(size(netEvThetaMean));
for condInd = 1:length(netEvConds);
    
    %get indices
    indToAverage = netEv == netEvConds(condInd);
    
    %get values
    valsToAverage = deltaView(indToAverage);
    
    %take mean and std
    netEvThetaMean(condInd) = mean(valsToAverage);
    netEvThetaSTD(condInd) = std(valsToAverage);
end
    
xVals = netEvConds + 0.1*randn(1,length(netEvConds));
%plot
errorbar(xVals,netEvThetaMean,netEvThetaSTD,'Marker',markerToPlot,...
    'LineStyle','-','Color',colorToPlot,'MarkerSize',15,'MarkerFaceColor',...
    colorToPlot,'MarkerEdgeColor',colorToPlot,'LineWidth',2);
xlabel('Net Evidence','FontSize',30);
ylabel('Change in View Angle','FontSize',30);
set(axH,'FontSize',20);
