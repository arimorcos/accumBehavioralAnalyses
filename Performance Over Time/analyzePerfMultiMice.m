function perf = analyzePerfMultiMice(mice,outFileName,heat,dateRange)
%analyzePerfMultiMice.m function to run analyzePerfOverTime on multiple
%mice
%
%mice - a cell array of mice to performa analysis on 
%dateRange - a 1x2 cell array containing the start and stop date for all miceOR a
%           nMice x 2 cell array containing the start and stop date for each mouse
%outFileName - filepath for output file
%heat - boolean of whether to plot heatmap or scatter

if nargin < 4; dateRange = []; end
if nargin < 3; heat = true; end

%get number of mice 
nMice = length(mice);

if isempty(dateRange)
    allDates = true;
else
    allDates = false;
    %check for single or multiple dateRanges
    if size(dateRange,1) == 1 && nMice > 1 %if single dateRange
        dateRange = repmat(dateRange,nMice,1);
    elseif size(dateRange,1) ~= 1 && size(dateRange,1) ~= nMice %if number of dateRanges does not match number of mice, throw error
        error('dateRange must contain as many ranges as nMice or only one');
    end
end

%delete file if exists
if exist([outFileName,'.pdf'],'file')
    delete([outFileName,'.pdf']);
end

for i = 1:nMice %for each mouse 
    
    dispProgress('Current Mouse: %s  Progress: %02d out of %02d\n',...
        i,mice{i},i,nMice);
    
    %run analyzePerf
    if allDates
        [perf.(mice{i}), figHandle] = analyzePerfOverTime(mice{i},heat,[],[],true);
    else
        [perf.(mice{i}), figHandle] = analyzePerfOverTime(mice{i},heat,dateRange{i,1},dateRange{i,2},true);
    end
    pause(0.1);
    
    %save figure
    for j = 1:length(figHandle) %for each figure
        export_fig(outFileName, '-pdf', '-nocrop', '-append', figHandle(j));
    end
    
    %delete fig
    delete(figHandle);
end

end