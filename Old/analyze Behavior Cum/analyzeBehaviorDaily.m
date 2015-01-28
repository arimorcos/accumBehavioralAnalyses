%analyzeBehaviorDaily

%This is a function to analyze the behavioral data for all animals on a
%given day. It computes several factors:
%
%number of rewards received
%amount of water earned
%amount of water to give
%total number of trials, 
%average trial time
%number of white conditions
%number of green conditions
%percent of trials in which a reward was given 

%all written to behavRes structure

%ASM 3/10/12

function [behavRes] = analyzeBehaviorDaily(date, startAn, stopAn)
%Amount dispensed 
singleWater = 4; % in uL
totalWater = 1000;

%Get list of folders in directory
folderList = dir('AM*'); 
for i=1:size(folderList,1) %convert string of last 3 characters (nums) into double in anNum array 
    anNum(i,1) = str2double(folderList(i).name(3:5)); %#ok<AGROW>
end
if exist('startAn','var')
    startAn = str2double(startAn(3:5)); %convert start and stop into array if they exist
end
if exist('stopAn','var')
    stopAn = str2double(stopAn(3:5));
end

%if inputs are empty, designate them as lowest and highest values
if nargin < 3
    stopAn = max(anNum);
end
if nargin < 2
    startAn = min(anNum);
end
if nargin < 1
    date = datestr(now,'yymmdd');
end
data = [];
%Go to each file from the current date and compare
for i=1:size(folderList,1) %For each animal
    if str2double(folderList(i).name(3:5)) < startAn || str2double(folderList(i).name(3:5)) > stopAn
        continue;
    end
    rootDir = cd(folderList(i).name); %change to directory
    fileList = what;
    findResult = strfind(fileList.mat,date);
    numRewards = 0;
    for j=1:size(findResult,1)
        if ~isempty(findResult{j}) %determine if date is present in any files
            load([folderList(i).name, '_',date]) %load that file 
            
            %calculate number of rewards
            numRewards = size(find(data(8,:)==1),2);
            
            %calculate trial end times
            itiTimes = find(data(9,:)==1)-1;
            trialEndTimes = itiTimes(find(data(9,itiTimes)==0))+1; %#ok<FNDSB>
            timeVecs = data(1,trialEndTimes); %FINISH LATER!!!!!
            
            %calculate total numbers of trials
            numTrials = size(trialEndTimes,2);
            if numTrials == 0
                numTrials = 1;
            end
            
            %calculate number of condition 1 trials
            cond1Trials = sum(data(7,trialEndTimes) == 1);
            
            %calculate number of condition 2 trials
            cond2Trials = sum(data(7,trialEndTimes) == 2);
            
            %calculate percent of trials in which a reward is given 
            percRewards = 100*numRewards/numTrials;            
        end
    end
    waterDisp = numRewards*singleWater; 
    waterToGive = totalWater - waterDisp;
    
    %Write everything to behavRes structure
    eval(['behavRes.',folderList(i).name,'.numRewards = numRewards;']);
    eval(['behavRes.',folderList(i).name,'.waterDisp = waterDisp;']);
    eval(['behavRes.',folderList(i).name,'.waterToGive = waterToGive;']); 
    eval(['behavRes.',folderList(i).name,'.numTrials = numTrials;']);
    eval(['behavRes.',folderList(i).name,'.cond1Trials = cond1Trials;']);
    eval(['behavRes.',folderList(i).name,'.cond2Trials = cond2Trials;']);
    eval(['behavRes.',folderList(i).name,'.percRewards = percRewards;']);
    
    %change back to original directory
    cd(rootDir);
end

end