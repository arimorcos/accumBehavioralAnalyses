function figHandle = heatMapPerfOverTime(perf, anName, silent)
%heatMapPerfOverTime.m function to plot performance over time for a given
%mouse

%rearrange data and generate legend entries for crutch/non-crutch
data = zeros(1,sum(~isnan([perf.crutchPerf perf.nonCrutchPerf])));
mazeNames = cell(size(data));
dates = cell(size(data));
ind = 1;
for i=1:length(perf.crutchPerf) %for each session
    if isnan(perf.crutchPerf(i)) %if nan skip to next one
        mazeNames{ind} = perf.mazeNames{i};
        dates{ind} = perf.dateIDs{i};
        data(ind) = perf.nonCrutchPerf(i);
        ind = ind + 1; %increment ind by 1
    else
        mazeNames{ind} = [perf.mazeNames{1,i},'_CRUTCHTRIALS'];
        mazeNames{ind+1} = [perf.mazeNames{1,i},'_NONCRUTCHTRIALS'];
        dates(ind:ind+1) = repmat(perf.dateIDs(i),1,2); %store date
        data(ind) = perf.crutchPerf(i);
        data(ind+1) = perf.nonCrutchPerf(i);
        ind = ind + 2; %increment ind by 2;
    end
end

mazeTypes = unique(mazeNames,'stable'); %find number of mazeTypes
diffDates = unique(dates);

%initialize heat array
heat = nan(length(mazeTypes),length(perf.dates));

%populate heat array
for i=1:length(data) %for each piece of data
    
    %find row and column index
    [~,rowInd] = ismember(mazeNames{i},mazeTypes); %rowInd is which unique mazeName matches
    [~,colInd] = ismember(dates{i},diffDates); %colInd is which date curr date matches
    
    %put data in array
    heat(rowInd,colInd) = data(i);
end

%create figure
figHandle = figure('Name',[anName, ':  Performance over time']);
if silent
    set(figHandle,'Visible','off');
end

%increase NaNs to higher than max
heat(isnan(heat(:))) = 110;

%customize colormap so that largest values are white
colordata = colormap;
colordata(end,:) = [1 1 1];
colormap(colordata);

%plot heatmap
heatHandle = imagesc(heat);
% xticklabel_rotate(1:length(diffDates),90,diffDates,'FontSize',15);
set(gca,'YTick',1:length(mazeTypes),'YTickLabel',mazeTypes,'FontSize',15);
if length(diffDates) >= 10
    tickVals = round(linspace(1,length(diffDates),10));
    set(gca,'XTick',tickVals,'XTickLabel',diffDates(tickVals),'FontSize',15);
else
    set(gca,'XTick',1:length(diffDates),'XTickLabel',diffDates,'FontSize',15);
end
currCLim = get(gca,'Clim');
set(gca,'CLim',[0 currCLim(2)])
xlabel('Date','FontSize',25);
ylabel('Maze','FontSize',25);
title([anName, ':  Performance over time'],'FontSize',25);

%colorbar
cBar = colorbar('FontSize',15);
ylabel(cBar,'Percent Correct','FontSize',25);
ylim(cBar,[0 100]);

set(figHandle,'Units','Normalized','OuterPosition',[0 0 1 1]);

end