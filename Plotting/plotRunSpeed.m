labels = {'22','28','33','34','37'};

figure;
colors = lines(5);


% for i=1:5
% hold on;
% % scatter(perf(i,3),perf(i,1),120,colors(i,:),'filled');
% errorbar(i,meanRunSpeed(i),stdRunSpeed(i),'MarkerFaceColor',colors(i,:),...
%     'MarkerEdgeColor',colors(i,:),'MarkerSize',15,'Marker','o',...
%     'Color',colors(i,:));
% end
boxplot(runSpeed);

xlabel('Mouse','FontSize',30)
ylabel('Trials Per Session','FontSize',30);
set(gca,'XTick',1:5);
set(gca,'XTickLabel',labels,'FontSize',20)
% ylim([75 175])
xlim([0 6])
