function printCondPerf(folder)

[allNames, ~, ~, ~, isDirs] = dir2cell(folder);
files = allNames(~isDirs);

%match string
matchFiles = files(~cellfun(@isempty,regexp(files,'.*_Cell.mat')));

%reverse 
matchFiles = flipud(matchFiles);

%open file 
root = '/mnt/7A08079708075215/DATA/Analyzed Data/160217_mouse_perf';
[~, base, ~] = fileparts(folder);
fid = fopen(fullfile(root, [base, '.txt']), 'w');

% loop through 
for ind = 1:length(matchFiles)
    
    %load dataCell
    load(fullfile(folder, matchFiles{ind}), 'dataCell');
    
    %determine if integraiton
    if ~strcmpi(dataCell{1}.info.name, 'Maze10_Spatial_Discrete_100Delay_cutTurn')
        continue
    end
    
    %remove crutch
    dataCell = getTrials(dataCell, 'maze.crutchTrial==0');
    
    %get 6-0 perf
    perf60 = sum(findTrials(dataCell, 'maze.numLeft==0,6;result.correct==1'))...
        /sum(findTrials(dataCell, 'maze.numLeft==0,6'));
    
    %5-1
    perf51 = sum(findTrials(dataCell, 'maze.numLeft==1,5;result.correct==1'))...
        /sum(findTrials(dataCell, 'maze.numLeft==1,5'));
    
    %4-2
    perf42 = sum(findTrials(dataCell, 'maze.numLeft==2,4;result.correct==1'))...
        /sum(findTrials(dataCell, 'maze.numLeft==2,4'));
    
    %3-3
    perf33 = sum(findTrials(dataCell, 'maze.numLeft==3;result.correct==1'))...
        /sum(findTrials(dataCell, 'maze.numLeft==3'));
    
    %print to file
    string = sprintf('File: %s | 6-0: %.2f | 5-1: %.2f | 4-2: %.2f | 3-3: %.2f \n',...
        matchFiles{ind}, perf60, perf51, perf42, perf33);
    fprintf(fid, string);
    fprintf(string);
        
    
    
end

fclose(fid);