function plotCutTurn(meanVals,stdVals,mazeTypes)
%plotCutTurn.m

%create figure
figH = figure;

%get nMazeTypes
nTypes = length(mazeTypes);

%plot
hold on;
nonCutPlot = errorbar(1:nTypes,meanVals(1,:),stdVals(1,:),'bo');
cutPlot = errorbar(1:nTypes,meanVals(2,:),stdVals(2,:),'ro');

%set limits
xlim([0.5 nTypes+0.5]);

%set xticks
set(gca,'XTick',1:nTypes,'XTickLabel',mazeTypes);
