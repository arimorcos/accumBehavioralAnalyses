function [perf] = getLinearTrackOverTime(anDir,allDates,startDate,stopDate)
%getPerfOverTime.m function to loop through an animal's files and process
%basic information to be returned in the perf structure
%
%ASM 7/19/13

%move to directory
origDir = cd(anDir);

%get list of all cell files
allCell = dir('*Cell*.mat');

if ~allDates
    %cull list
    ind = 1;
    for i=1:length(allCell) %for each mouse
        cellDate = str2double(allCell(i).name(7:12));
        if cellDate >= str2double(startDate) && cellDate <= str2double(stopDate)
            cellFiles{ind} = allCell(i).name;
            ind = ind + 1;
        end
    end
else
    cellFiles = {allCell(:).name};
end

%generate corresponding non-cell files
matFiles = cellfun(@(x) regexp(x,'_Cell','split'),cellFiles,'UniformOutput',false);%remove '_Cell'
matFiles = cellfun(@(x) [x{:}],matFiles,'UniformOutput',false);

%get dateIDs
perf.dateIDs = cellfun(@(x) regexp(x,'(?<=_)\d*\w*(?=.mat)','match'),matFiles,'UniformOutput',false);
perf.dateIDs = cellfun(@(x) x{1},perf.dateIDs,'UniformOutput',false);

%loop through each file and get trials per minute
perf.lengths = cell(1,length(cellFiles)); %initialize lengths
perf.dates = cellfun(@(x) x(7:12),cellFiles,'UniformOutput',false);

ind = 1;

for i=1:length(cellFiles) %for each cell file
    
    load(cellFiles{i},'dataCell'); %load dataCell
    load(matFiles{i},'data','exper'); %load data and exper
    
    %ensure linearTrack
    if ~strcmp(func2str(exper.experimentCode),'Linear_Track_2Cond') %if not linear track
        continue;
    end
    
    if isfield(dataCell{1}.maze,'mazeLength')
        perf.lengths{ind} = getCellVals(dataCell,'maze.mazeLength');
        ind = ind + 1;
    else
        continue;
    end
end

%change back to original dir
cd(origDir);