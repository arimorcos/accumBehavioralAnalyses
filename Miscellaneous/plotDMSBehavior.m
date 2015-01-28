figure;
% colors = lines(7);
% 
% 
% for i=1:7
% hold on;
% % scatter(perf(i,3),perf(i,1),120,colors(i,:),'filled');
% errorbar(perf(i,3),perf(i,1),perf(i,2),'MarkerFaceColor',colors(i,:),...
%     'MarkerEdgeColor',colors(i,:),'MarkerSize',15,'Marker','o',...
%     'Color',colors(i,:));
% end
errorbar(1:7,perf(:,1),perf(:,2),'MarkerSize',15,'Marker','o',...
    'MarkerFaceColor','b','MarkerEdgeColor','b','LineStyle','none');



labels = {'7','8','9','11','13','22','34'};
xlabel('Mouse','FontSize',20)
ylabel('Percent Correct','FontSize',20);
set(gca,'XTick',1:7)
set(gca,'XTickLabel',labels,'FontSize',15)
ylim([0 100])
title('Performance on Delayed Match To Sample Tasks','FontSize',20);
xlim([0 8])
% legend(labels,'FontSize',20)