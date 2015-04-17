function plotDecModelParams(goodParams)
names = {'weightSlope','weightOffset','bias_{mu}','bias_{sigma}',...
    'lambda','boundDist','prevTurnWeight','weightScale'};

% create figure
figure;
axH = axes;
hold(axH,'on');

%get values
meanVals = mean(goodParams);
xVals = repmat(1:size(goodParams,2),size(goodParams,1),1);

% create plot 
scatH = scatter(xVals(:), goodParams(:));
meanH = scatter(1:size(goodParams,2), meanVals);
meanH.Marker = '+';
meanH.SizeData = 120;
meanH.MarkerEdgeColor = 'k';
meanH.LineWidth = 2;

% add text labels
for i = 1:length(meanVals)
    text(i+0.09,meanVals(i)+0.05,num2str(meanVals(i)));
end

% set xlabels
axH.XTickLabel = names;
axH.XTickLabelRotation = -45;

axH.XLim = [-0.5 size(goodParams,2) + 0.5];
axH.XTick = 1:size(goodParams,2);
axH.FontSize = 20;