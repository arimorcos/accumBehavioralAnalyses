%plotRigTransition.m 

HIGHLIGHT = [90 100];

%create figure
figH = figure;

%create tpm subplot
subplot(2,1,1);

colors = distinguishable_colors(length(miceTPM));

hold on;
%plot
for i = 1:length(miceTPM)
    plotHand= plot(labels,tpm(i,:),'o-','Color',colors(i,:),'LineWidth',2);
    if ~isempty(HIGHLIGHT) && ~ismember(miceTPM(i),HIGHLIGHT)
        set(plotHand,'Color',[.75 .75 .75]);
    end
end

letters = mat2cell(65:90,1,ones(size(65:90)));
letters = cellfun(@(x) char(x),letters,'UniformOutput',false);
letters = letters(1:length(miceTPM));
legend(letters,'Location','SouthWest');

%label axes
ylabel('Trials Per Minute');
set(gca,'XTickLabel','');

%create percCorr subplot
subplot(2,1,2);
hold on;
colorSub = colors(ismember(miceTPM,micePercCorr),:);
%plot
for i = 1:length(micePercCorr)
    plotHand = plot(labels,percCorr(i,:),'o-','color',colorSub(i,:),'LineWidth',2);
    
    if ~isempty(HIGHLIGHT) && ~ismember(micePercCorr(i),HIGHLIGHT)
        set(plotHand,'Color',[.75 .75 .75]);
    end
end

percCorrLett = letters(ismember(miceTPM,micePercCorr));
legend(percCorrLett,'Location','SouthWest');

%label axes
ylabel('Percent Correct');
xlabel('Session Relative to Rig Transition');
ylim([0 100]);