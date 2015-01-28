function plotTrialRasterCellStandalone(dataCell)
%plotTrialRasterCell.m Plots raster of trials in gui
%
%ASM 9/19/12 edited 7/3/13

%plot trial conditions
guiObjects.trialRaster = axes;
cla reset;
xlabel('Window End Time'); %set xlabel
set(gca,'YTickLabel','','YTick',[]); %delete y ticks
% load('MyColormaps.mat','blackGreyColor'); %load custom colormap
if ~isempty(dataCell)
    nConds = length(dataCell{1}.info.conditions);
    if length(unique(getCellVals(dataCell,'maze.condition'))) > nConds
        nConds = length(unique(getCellVals(dataCell,'maze.condition')));
    end
%     cmapCustom = blackGreyColor(round(linspace(1,size(blackGreyColor,1),...
%         nConds)),:); %#ok<NODEF> %set colormap 
    cmapCustom = jet(nConds);
else
%     cmapCustom = blackGreyColor(round(linspace(1,size(blackGreyColor,1),4)),:);
end


guiObjects.rasterHandle = zeros(size(dataCell));
guiObjects.shadeHandle = gobjects(size(dataCell));
rasterLocation = zeros(size(dataCell));
yBounds = get(gca,'ylim');
newCellFlag = false;
for i=1:size(dataCell,2)
    dataInd = find(i <= cumDataTrials,1,'first');
    ind = find(dataCell{i}.time.stop >= data{dataInd}(1,:),1,'last'); %find the last point at which the stop time is greater
    totPrevInd = 0;
    for j=1:dataInd-1
        totPrevInd = totPrevInd + size(data{j},2);
    end
    ind = ind + totPrevInd;

    if i==1 && i~=size(dataCell,2)
        halfInd(1) = 1;
        halfInd(2) = ind + (find(dataCell{i+1}.time.stop >= data{dataInd}(1,:),1,'last') - ind)/2;
    elseif i~=1 && i==size(dataCell,2)
        halfInd(1) = ind - (ind - find(dataCell{i-1}.time.stop >= data{dataInd}(1,:),1,'last'))/2;
        halfInd(2) = totTime;
    elseif i==1 && i==size(dataCell,2)
        halfInd(1) = 1;
        halfInd(2) = totTime;
    elseif newCellFlag
        halfInd(1) = ind - (ind - pastInd)/2;
        halfInd(2) = ind + (totPrevInd + find(dataCell{i+1}.time.stop >= data{dataInd}(1,:),1,'last') - ind)/2;
        newCellFlag = false;
    elseif ismember(i,cumDataTrials)
        newCellFlag = true;
        pastInd = ind;
        halfInd(1) = ind - (ind - find(dataCell{i-1}.time.stop >= data{dataInd}(1,:),1,'last'))/2;
        halfInd(2) = ind + ((size(data{dataInd},2)-ind) + find(dataCell{i+1}.time.stop >= data{dataInd+1}(1,:),1,'last'))/2;
    else
        halfInd(1) = ind - (ind - find(dataCell{i-1}.time.stop >= data{dataInd}(1,:),1,'last'))/2;
        halfInd(2) = ind + (totPrevInd + find(dataCell{i+1}.time.stop >= data{dataInd}(1,:),1,'last') - ind)/2;
    end
    
    if ismember(i,cumDataTrials)
        newCellFlag = true;
        pastInd = ind;
    else
        newCellFlag = false;
    end
    
    halfInd = halfInd/totTime;
    if dataCell{i}.result.correct
        guiObjects.shadeHandle(i) = patch([halfInd(1) halfInd(2) halfInd(2) halfInd(1)],...
            [yBounds(2) yBounds(2) yBounds(1)+0.8*(yBounds(2)-yBounds(1)) yBounds(1)+0.8*(yBounds(2)-yBounds(1))],...
            [0.18 0.8 0.44],'EdgeColor','none');
    else
        guiObjects.shadeHandle(i) = patch([halfInd(1) halfInd(2) halfInd(2) halfInd(1)],...
            [yBounds(2) yBounds(2) yBounds(1)+0.8*(yBounds(2)-yBounds(1)) yBounds(1)+0.8*(yBounds(2)-yBounds(1))],...
            [0.9 0.36 0.36],'EdgeColor','none');
    end
    guiObjects.rasterHandle(i) = line([ind/totTime ind/totTime],[yBounds(1) yBounds(1)+.8*(yBounds(2)-yBounds(1))]);
    set(guiObjects.rasterHandle(i),'ButtonDownFcn',{@rasterClick_CALLBACK,...
        dataCell,i});
    rasterLocation(i) = ind/totTime;
    set(guiObjects.rasterHandle(i),'Color',cmapCustom(dataCell{i}.maze.condition,:),'LineWidth',3);
end
xlim([0 1]);
xTickVals = num2cell(timeVec(round(linspace(1,length(timeVec),11))));
xTickDates = cellfun(@(x) datestr(x,'HH:MM:SS'),xTickVals,'UniformOutput',false);
set(gca,'XTickLabel',xTickDates);

%reverse object draw order
set(gca,'children',flipud(get(gca,'children')));

%create trial cond legend
if isfield(guiObjects,'trialCondLegend') && ishandle(guiObjects.trialCondLegend)
    delete(guiObjects.trialCondLegend);
end
guiObjects.trialCondLegend = subplot('Position',[0.02 0.6025 0.9 0.0175]);
set(gca,'visible','off');
xlim([0 1]);
for i = 1:size(cmapCustom,1)
    line([i/24 i/24],[0 1],'Color',cmapCustom(i,:),'LineWidth',3);
    text(.0417*i+.01,.5,num2str(i),'Color',cmapCustom(i,:),'HorizontalAlignment','Left');
end

end

