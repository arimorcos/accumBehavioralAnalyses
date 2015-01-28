color = cat(1,hsv(length(DMSData)),hsv(length(DMSData)));

figure;
hold on;

for i=1:length(DMSData)
handles(i) = scatter([1 2],[DMSData(2,i) DMSData(3,i)],100,color(i,:),'filled');
end

x=num2cell(DMSData(1,:));
x = cellfun(@(x) num2str(x),x,'UniformOutput',false);

%add means
contMean = mean(DMSData(3,~isnan(DMSData(3,:))));
contSTD = std(DMSData(3,~isnan(DMSData(3,:))));
DMSMean = mean(DMSData(2,~isnan(DMSData(2,:))));
DMSSTD = std(DMSData(2,~isnan((DMSData(2,:)))));

errorbar([1 2],[DMSMean contMean],[DMSSTD contSTD],'sk','MarkerSize',15);

legend([x,'Mean +- std'],'Location','NorthEastOutside');

set(gca,'XTick',[1 2]);
set(gca,'XTickLabel',{'Delayed Match to Sample (700 or more)','Continuity'},'FontSize',20);

ylim([0 100]);
ylabel('Percent Correct');


line([0 3],[50 50],'LineStyle','--','Color','k','LineWidth',2);
text(3.1,50,'Chance','FontSize',20);


