function plotDecModelTraces(traces,dataCell)
%plots traces of decision model

%get trials which end in left turn 
leftTurn = getCellVals(dataCell,'result.leftTurn==1');

%plot according to that 
figH = figure;
axH = axes;
hold(axH,'on');

%get yPosBins
yPosBins = -50:5:600;

%plot traces
colors = distinguishable_colors(2);
plotH = gobjects(length(dataCell),1);
for i = 1:length(dataCell)
    plotH(i) = plot(yPosBins,traces(i,:),'Color',colors(double(leftTurn(i)+1),:));
end

%label axes 
axH.XLabel.String = 'Y Position';
axH.YLabel.String = 'Decision Variable';
axH.FontSize = 20;
legend([plotH(find(leftTurn==true,1,'first')) plotH(find(leftTurn==false,1,'first'))],...
    {'Left turn','Right turn'},'Location','Best');


