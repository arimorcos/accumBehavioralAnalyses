%get which mice are which
oldFields = {'AM103','AM112','AM113','AM097','AM081','AM090'};
newFields = {'AM119','AM120'};
allFields = cat(1,oldFields(:),newFields(:));

%get unique maze names
mazeNames = unique(perf.(oldFields{1}).mazeNames,'stable');
mazeNames = cellfun(@(x) x(1:10),mazeNames,'UniformOutput',false);
mazeNames = unique(mazeNames,'stable');

%create figure
figHandle = figure;
hold on;

colors = distinguishable_colors(length(allFields));

for i = 1:length(oldFields)
    
    mazeVals = zeros(size(perf.(oldFields{i}).mazeNames));
    currNames = perf.(oldFields{i}).mazeNames;
    currNames = cellfun(@(x) x(1:10),currNames,'UniformOutput',false);
    
    %assign number to each maze
    for j = 1:length(mazeNames)
        mazeVals(strcmp(currNames,mazeNames{j})) = j;
    end
    
    plot(mazeVals,'--','Color',colors(i,:),'LineWidth',0.5);
    
end

for i = 1:length(newFields)
    
    mazeVals = zeros(size(perf.(newFields{i}).mazeNames));
    currNames = perf.(newFields{i}).mazeNames;
    currNames = cellfun(@(x) x(1:10),currNames,'UniformOutput',false);
    
    %assign number to each maze
    for j = 1:length(mazeNames)
        mazeVals(strcmp(mazeNames{j},currNames)) = j;
    end
    
    plot(mazeVals,'-','Color',colors(i+length(oldFields),:),'LineWidth',4);
    
end
    

%set lim
xlim([1,length(perf.(newFields{1}).mazeNames)+10]);
ylim([1,length(mazeNames)]);

%set labels
set(gca,'FontSize',20);
xlabel('Session #','FontSize',25);
ylabel('Maze','FontSize',25);
set(gca,'yticklabel',mazeNames(get(gca,'ytick')));

%% TPM

meanTPMOld = nan(length(oldFields),length(mazeNames));
stdTPMOld = nan(length(oldFields),length(mazeNames));
for i = 1:length(oldFields)
    
    currNames = perf.(oldFields{i}).mazeNames;
    currNames = cellfun(@(x) x(1:10),currNames,'UniformOutput',false);
    
    %for each mazeName
    for j = 1:length(mazeNames)
        
        %get tpm of those mazeNames
        tpm = perf.(oldFields{i}).tpm(strcmp(mazeNames{j},currNames));
        
        %store 
        if ~isempty(tpm)
            meanTPMOld(i,j) = mean(tpm);
            stdTPMOld(i,j) = std(tpm);
        else
            meanTPMOld(i,j) = nan;
            stdTPMOld(i,j) = nan;
        end
    end
    
end

meanTPMNew = nan(length(newFields),length(mazeNames));
stdTPMNew = nan(length(newFields),length(mazeNames));
for i = 1:length(newFields)
    
    currNames = perf.(newFields{i}).mazeNames;
    currNames = cellfun(@(x) x(1:10),currNames,'UniformOutput',false);
    
    %for each mazeName
    for j = 1:length(mazeNames)
        
        %get tpm of those mazeNames
        tpm = perf.(newFields{i}).tpm(strcmp(mazeNames{j},currNames));
        
        %store 
        %store 
        if ~isempty(tpm)
            meanTPMNew(i,j) = mean(tpm);
            stdTPMNew(i,j) = std(tpm);
        else
            meanTPMNew(i,j) = nan;
            stdTPMNew(i,j) = nan;
        end
    end
    
    
end

%create figure
figure;
hold on;
scatterSize = 100;

%scatter old
for i = 1:length(oldFields)
%     scatter(1:length(mazeNames),meanTPMOld(i,:),scatterSize,colors(i,:));
    errorbar((1:length(mazeNames))+0.1*randn(1,length(mazeNames)),meanTPMOld(i,:),stdTPMOld(i,:),'LineStyle','none',...
        'Color',colors(i,:),'Marker','o','MarkerSize',10);
end

%scatter new
for i = 1:length(newFields)
    %     scatter(1:length(mazeNames),meanTPMNew(i,:),scatterSize,colors(length(oldFields)+i,:),'fill');
    errorbar((1:length(mazeNames))+0.1*randn(1,length(mazeNames)),meanTPMNew(i,:),stdTPMNew(i,:),'LineStyle','none',...
        'Color',colors(i,:),'Marker','o','MarkerFaceColor',colors(i,:),'markersize',10);
end

%labels
set(gca,'FontSize',20);
ylabel('Trials Per Minute','FontSize',25);
% xlim([1 length(mazeNames)]);
% set(gca,'xticklabel',mazeNames(get(gca,'xtick')));
% rotateXLabels(gca,30);
xlabel('Maze #','FontSize',25);

