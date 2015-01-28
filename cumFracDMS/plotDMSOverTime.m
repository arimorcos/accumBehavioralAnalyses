LETTERS = true;
DIFFCOLORS = false;
DIFFMARKERS = false;
HIGHLIGHT = [];


figH = figure; 

colors = distinguishable_colors(length(DMSMice));
markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
    '+','*','o','x','^','<','h','.','>','p','s','d','v',...
    'o','x','+','*','s','d','v','^','<','>','p','h','.'];

subplot(1,2,1);
hold on;

for i=1:length(DMSMice) %for each mouse
    if DIFFCOLORS
        plotHand = plot(DMSOverTime(i,:),'Color',colors(i,:),'LineWidth',2);
    else
        plotHand = plot(DMSOverTime(i,:),'Color','b','LineWidth',2);
    end
    if DIFFMARKERS
        set(plotHand,'Marker',markers(i));
    else
        set(plotHand,'Marker','none');
    end
    
    if HIGHLIGHT == DMSMice(i) %if should highlight
        set(plotHand,'Color','r');
    elseif ~isempty(HIGHLIGHT)
        set(plotHand,'Color',[.75 .75 .75]);
    end
        
end
ylim([0 100]);
lim = get(gca,'xlim');
hLine = line(lim,[50 50],'LineStyle','--','Color','k','LineWidth',2);
text(0.99*lim(2),50,'Chance','FontSize',20,'VerticalAlignment','Bottom','HorizontalAlignment','Right');

letters = mat2cell(65:90,1,ones(size(65:90)));
letters = cellfun(@(x) char(x),letters,'UniformOutput',false);
letters = letters(1:length(DMSMice));

mName = mat2cell(DMSMice,ones(numel(DMSMice),1),1);
mName = cellfun(@(x) num2str(x),mName,'UniformOutput',false);
if DIFFCOLORS
    if ~LETTERS
        legend(mName,'Location','SouthWest');
    else
        legend(letters,'Location','SouthWest');
    end
end

ylabel('Percent Correct','FontSize',25);
set(gca,'FontSize',15);
xlabel('Session Number','FontSize',25);

scatAx = subplot(1,2,2);
hold on;

for i = 1:length(DMSMice)
    
    scatHand = scatter(i*ones(size(DMSOverTime(i,:))),DMSOverTime(i,:));
    set(scatHand,'SizeData',200,'MarkerEdgeColor','b','LineWidth',2);
    
    if HIGHLIGHT == DMSMice(i) %if should highlight
        set(scatHand,'MarkerEdgeColor','r');
    elseif ~isempty(HIGHLIGHT)
        set(scatHand,'MarkerEdgeColor',[.75 .75 .75]);
    end
    
end
if ~LETTERS
    set(scatAx,'XTick',[1:max(x(:))],'XTickLabel',mName);
else
    set(scatAx,'XTick',[1:length(DMSMice)],'XTickLabel',letters);
end
ylabel('Percent Correct','FontSize',25);
set(gca,'FontSize',15);
ylim([0 100]);
xlim([0 length(DMSMice)+1]);
xlabel('Mouse','FontSize',25);
pause(0.1);
lim = get(scatAx,'xlim');
hLine = line(lim,[50 50],'LineStyle','--','Color','k','LineWidth',2);
text(0.99*lim(2),50,'Chance','FontSize',20,'VerticalAlignment','Bottom','HorizontalAlignment','Right');
    