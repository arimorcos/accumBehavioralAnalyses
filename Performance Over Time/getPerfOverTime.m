function [perf] = getPerfOverTime(anDir,allDates,startDate,stopDate)
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
perf.tpm = zeros(1,length(cellFiles)); %initialize tpm
perf.dates = cellfun(@(x) x(7:12),cellFiles,'UniformOutput',false);
perf.mazeNames = cell(1,length(cellFiles)); %initialize maze names
perf.crutchPerf = zeros(1,length(cellFiles));
perf.nonCrutchPerf = zeros(1,length(cellFiles));

for i=1:length(cellFiles) %for each cell file
    
    load(cellFiles{i},'dataCell'); %load dataCell
    load(matFiles{i},'data','exper'); %load data and exper
    
    %get total session time in minutes
    sessionTime = datevec(data(1,end)-data(1,1));
    sessionTime = sessionTime(4)*60 + sessionTime(5) + sessionTime(6)/60;
    
    %get total trials
    nTrials = length(dataCell);
    
    %calculate trials per minute
    perf.tpm(i) = nTrials/sessionTime;
    
    %get mazeNames
    perf.mazeNames{i} = dataCell{1}.info.name;
    
    if isfield(dataCell{1}.maze,'crutchTrial') %if contains crutchTrials
        crutchTrials = getTrials(dataCell,'maze.crutchTrial==1');
        nonCrutchTrials = getTrials(dataCell,'maze.crutchTrial == 0');
        perf.crutchPerf(i) = 100*sum(getCellVals(crutchTrials,'result.correct'))/length(crutchTrials);
        perf.nonCrutchPerf(i) = 100*sum(getCellVals(nonCrutchTrials,'result.correct'))/length(nonCrutchTrials);
    else
        perf.nonCrutchPerf(i) = 100*sum(getCellVals(dataCell,'result.correct'))/length(dataCell);
        perf.crutchPerf(i) = NaN;
    end
    
    if isfield(dataCell{1}.maze,'twoTowers') %if contains paired
        crutchTrials = getTrials(dataCell,'maze.twoTowers == 0');
        nonCrutchTrials = getTrials(dataCell,'maze.twoTowers == 1');
        perf.crutchPerf(i) = 100*sum(getCellVals(crutchTrials,'result.correct'))/length(crutchTrials);
        perf.nonCrutchPerf(i) = 100*sum(getCellVals(nonCrutchTrials,'result.correct'))/length(nonCrutchTrials);
    end
    
end

%change back to original dir
cd(origDir);