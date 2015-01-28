function plotTPM(ballChange,tpm,dates,mazeLength,mouseList)
%plotTPM.m plots trials per minute over time
%
%ballChange - string or cell array of dates in yymmdd
%tpm - cell array of row arrays containing trials per minute of each
%   session
%dates - cell array of row arrays containing dates of each
%   session
%mazeLength - cell array of row arrays containing maze lengths for each
%   session
%mouseList - cell array of strings containing mouse names

%controls
plotInd = true;
plotAll = false;
plotDiff = true;

%determine subplot size
squares = (1:10).^2;
dist = squares - length(mouseList);
dist(dist < 0) = NaN;
[~,ind] = min(dist);

%convert ballChange to cell
if ~iscell(ballChange)
    ballChange = {ballChange};
end

%get list of unique maze lengths
uniqueML = unique([mazeLength{:}]);
uniqueMLStr = arrayfun(@(x) num2str(x),uniqueML,'UniformOutput',false);
numML = length(uniqueML);

%generate colormap
colors = distinguishable_colors(numML);

if plotInd
    %create figure
    figure;
    h=tight_subplot(ind,ind);
    for i=1:length(mouseList) %for each mouse
%         tight_subplot(ind,ind,i); %make a subplot
        axes(h(i));
        [~,gVar] = ismember(mazeLength{i},uniqueML);
        gscatter(datenum(dates{i},'yymmdd'),tpm{i},gVar,colors);
        hold on;
        plot(datenum(dates{i},'yymmdd'),tpm{i},'r');
        title(mouseList{i});
        pause(0.05);
        datetick('x','yymmdd'); %convert xtick to dates
        xticklabel_rotate([],60);

        %plot ball change line
        for j=1:length(ballChange)
            line([datenum(ballChange{j},'yymmdd') datenum(ballChange{j},'yymmdd')],get(gca,'ylim'));
        end

        legend(uniqueMLStr(1:length(unique(mazeLength{i}))),'Location','NorthEastOutside');

    end
    delete(h(i+1:length(h)))
end

if plotAll || plotDiff
    allDates = unique(([dates{:}]));
    allData = zeros(length(mouseList),length(allDates));
    for i=1:length(mouseList)
       
        for j=1:length(tpm{i})
            allData(i,strcmp(dates{i}{j},allDates)) = tpm{i}(j);
        end
    end
end

if plotAll
    figure;
    markers=['o','x','+','*','s','d','v','^','<','>','p','h','.',...
    '+','*','o','x','^','<','h','.','>','p','s','d','v',...
    'o','x','+','*','s','d','v','^','<','>','p','h','.'];
    
    for i=1:length(mouseList)
        [~,gVar] = ismember(mazeLength{i},uniqueML);
        gscatter(datenum(dates{i},'yymmdd'),tpm{i},gVar,colors,markers(i));
        hold on;
    end

    plot(datenum(allDates,'yymmdd'),mean(allData),'k');
    datetick('x','yymmdd');
    xticklabel_rotate([],60);
    legend(mouseList);
    xlabel('Date');
    ylabel('Trials Per Minute');
    title('All Mice');

    %plot ball change line
    for j=1:length(ballChange)
        line([datenum(ballChange{j},'yymmdd') datenum(ballChange{j},'yymmdd')],get(gca,'ylim'));
    end
end

if plotDiff
    ballInd = find(strcmp(allDates,ballChange{1})==1);
    dataSub = allData(:,ballInd-2:ballInd+2);
    diffTPM = diff(dataSub,1,2);
    figure;
    boxplot(diffTPM);
    ylabel('Change in Trials Per Minute');
    set(gca,'xtick',1:4,'XTickLabel',{'Day -1 - Day -2'; 'Day 0 - Day -1';'Day 1 - Day 0';'Day 2 - Day 1'});
    
    %statistics
    
end
