function figHandle = scatterPerfOverTime(perf, anName, plots, silent)
%plotPerfOverTime.m function to plot performance over time for a given
%mouse
%
%perf - structure containing performance data
%anName - string with animal name
%plots - structure containing booleans for each plot
%silent - flag of whether or not to make plot visible

if ~plots.tpm && ~plots.perf
    return;
end

%generate legend entries for crutch/non-crutch
origMazeNames = perf.mazeNames;
for i=1:length(perf.crutchPerf) %for each day
    if isnan(perf.crutchPerf(i)) %if nan skip to next one
        perf.mazeNames{2,i} = '';
    else
        perf.mazeNames{2,i} = [perf.mazeNames{1,i},'_CRUTCHTRIALS'];
        perf.mazeNames{1,i} = [perf.mazeNames{1,i},'_NONCRUTCHTRIALS'];
    end
end

[groups, ~, gInd] = unique(perf.mazeNames); %find number of groups

%generate colormap
colors = distinguishable_colors(length(groups));

%generate xDate
xDate = datenum(perf.dates,'yymmdd');
xDate = cat(2,xDate,xDate);
xDate = reshape(xDate',numel(xDate),1);

%generate perfVals
perfVals = reshape(cat(1,perf.nonCrutchPerf,perf.crutchPerf),size(xDate));

%generate marker style array
symArray(1,:) = char(111*ones(size(perf.crutchPerf))); %corresponds to 'o'
symArray(2,:) = char(94*ones(size(perf.crutchPerf))); %corresponds to '^'
symArray = reshape(symArray,numel(symArray),1);

%create figure
figHandle = figure('Name',[anName, ':  performance over time']);
if silent
    set(figHandle,'Visible','off');
end

%make scatter plot
if plots.perf && plots.tpm
    subplot(2,1,1);
end
if plots.perf
    h=gscatter(xDate,perfVals,gInd,colors,symArray,12*ones(size(xDate)),'off');

    %fill in non-crutch trials
    for i=1:length(h) %for each group
        if ~isempty(regexp(groups{i},'_CRUTCHTRIALS', 'once')) %if is crutch trial
            continue;
        else
            set(h(i),'MarkerFaceColor',get(h(i),'Color'));
        end
    end

    %fix date
    lims = get(gca,'xlim');
    lims = [lims(1)-1 lims(2)+1];
    set(gca,'xlim',lims);
    pause(0.2);
    datetick(gca,'x','yymmdd','keeplimits');
    xlab = cellstr(get(gca,'XTickLabel'));
    xlab{1} = '';
    xlab{2} = '';
    xlab{end-1} = '';
    xlab{end} = '';
    set(gca,'XTickLabel',xlab);
    % xticklabel_rotate([],60);

    %labels
    xlabel('Date');
    ylabel('Percent Correct');
    title(anName);
    ylim([0 100]);

    %legend
    if isempty(groups{1})
        leg=legend(h(2:end),groups(2:end),'Interpreter','none');
    else
        leg=legend(h,groups,'Interpreter','none');
    end
    set(leg,'Location','SouthEast');
    title([anName, ':  performance over time']);
end

%tpm plot
if plots.tpm && plots.perf
    subplot(2,1,2);
elseif plots.tpm && ~plots.perf
    [tpmGroups, ~, tpmGroupInd] = unique(origMazeNames); %find number of groups
    hTPM = gscatter(datenum(perf.dates,'yymmdd'),perf.tpm,tpmGroupInd,...
        distinguishable_colors(length(tpmGroups)),[],50,'off');
    
    %fix date
    lims = get(gca,'xlim');
    set(gca,'xlim',[lims(1)-1 lims(2)+1]);
    datetick(gca,'x','yymmdd','keeplimits');
    drawnow;
    pause(0.1);
    xlab = cellstr(get(gca,'XTickLabel'));
    xlab{1} = '';
    xlab{end} = '';
    set(gca,'XTickLabel',xlab);
    
    %legend
    if isempty(groups{1})
        legTPM = legend(hTPM(2:end),tpmGroups(2:end),'FontSize',15,'Interpreter','none');
    else
        legTPM = legend(hTPM,tpmGroups,'FontSize',15,'Interpreter','none');
    end
    set(legTPM,'Location','NorthWest');
    
    xlabel('Date');
    ylabel('Trials Per Minute');
    title([anName, ':  performance over time']);
end




set(figHandle,'Units','Normalized','OuterPosition',[0 0 1 1]);

end