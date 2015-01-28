function [tpm, dates, mazeLength] = getTPM(anName,mouseDir,startDate,stopDate)
%getTPM.m function to get trials per minute for a given date range
%
%anName - string of anName ex. 'AM060'
%mouseDir - string of mouse directory ex. 'D:\Data\Ari\Current Mice'
%starDate - string of start date in yymmdd ex. '130612'
%stopDate - string of stop date in yymmdd ex. '130701'
%
%ASM 7/13

SCALEFACS = [-0.5 1 1.5 2 2.5 3]; %scale factors for maze relative to 100 maze in order - 40 100 200 300 400 500

fullAnDir = fullfile(mouseDir,anName);

%throw error if directory doesn't exist
if exist(fullAnDir,'dir') == 0
    error('Folder does not exist');
end

%move to directory
origDir = cd(fullAnDir);

%get list of all cell files
allCell = dir('*Cell*.mat');

%cull list
ind = 1;
for i=1:length(allCell) %for each mouse
    cellDate = str2double(allCell(i).name(7:12));
    if cellDate >= str2double(startDate) && cellDate <= str2double(stopDate)
        cellFiles{ind} = allCell(i).name;
        ind = ind + 1;
    end
end

%generate corresponding non-cell files
matFiles = cellfun(@(x) regexp(x,'_Cell','split'),cellFiles,'UniformOutput',false);%remove '_Cell'
matFiles = cellfun(@(x) [x{:}],matFiles,'UniformOutput',false);


%loop through each file and get trials per minute
tpm = zeros(1,length(cellFiles)); %initialize tpm
dates = cellfun(@(x) x(7:12),cellFiles,'UniformOutput',false);
mazeLength = zeros(1,length(cellFiles)); %initialize mazeLength
for i=1:length(cellFiles) %for each cell file
    
    load(cellFiles{i},'dataCell'); %load dataCell
    load(matFiles{i},'data','exper'); %load data and exper
    
    %get total session time in minutes
    sessionTime = datevec(data(1,end)-data(1,1));
    sessionTime = sessionTime(4)*60 + sessionTime(5) + sessionTime(6)/60;
    
    %get total trials
    nTrials = length(dataCell);
    
    %calculate trials per minute
    tpm(i) = nTrials/sessionTime;
    
    %get maze length
    if isfield(exper.variables,'mazeLengthAhead')
        mazeLength(i) = str2double(exper.variables.mazeLengthAhead);
    else
        mazeLength(i) = str2double(exper.variables.MazeLengthAhead);
    end
    
%     scale maze length relative to 100 maze
%     switch mazeLength(i)
%         case 40
%             tpm(i) = SCALEFACS(1)*tpm(i);
%         case 100
%             tpm(i) = SCALEFACS(2)*tpm(i);
%         case 200
%             tpm(i) = SCALEFACS(3)*tpm(i);
%         case 300
%             tpm(i) = SCALEFACS(4)*tpm(i);
%         case 400
%             tpm(i) = SCALEFACS(5)*tpm(i);
%         case 500
%             tpm(i) = SCALEFACS(6)*tpm(i);
%     end    
    
end

%change back to original dir
cd(origDir);
end