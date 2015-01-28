%% cumFrac

[f,x] = ecdf(cumFrac(:,3));

figH = figure;
h = plot(x,f,'b','LineWidth',3);


xlabel('Number of sessions to criterion','FontSize',25);
ylabel('Cumulative probability','FontSize',25);
set(gca,'FontSize',15);
xlim([0 max(x)]);

text(0.9*max(x),0.1*max(f),['n = ',num2str(size(cumFrac,1))],'HorizontalAlignment','Center',...
    'FontSize',20);

%% boxplot of performance
figH = figure;
h = boxplot(cumFrac(:,2));

ylabel('Percent Correct','FontSize',25);
set(gca,'FontSize',15);
lim = get(gca,'xlim');
ylim([0 100]);

text(0.75*lim(2),mean(cumFrac(:,2)),['n = ',num2str(size(cumFrac,1))],'HorizontalAlignment','Center',...
    'FontSize',20);

hLine = line([-10 10],[50 50],'LineStyle','--','Color','k','LineWidth',2);
text(0.99*lim(2),50,'Chance','FontSize',20,'VerticalAlignment','Bottom','HorizontalAlignment','Right');
set(gca,'XTickLabel','none');

%% all TPM

figH = figure;

hist(allTPM(:));

ylabel('Number of Sessions','FontSize',25);
set(gca,'FontSize',15);
xlabel('Trials Per Minute','FontSize',25);

%% all trials

figH = figure;

hist(allTrials(:));

ylabel('Number of Sessions','FontSize',25);
set(gca,'FontSize',15);
xlabel('Number of Trials','FontSize',25);

