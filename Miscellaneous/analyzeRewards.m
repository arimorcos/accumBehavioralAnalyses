%analyzeRewards.m

%This is a function to analyze the number of rewards each mouse for a given
%day and report the number of rewards, the amount of water drunk, and the
%amount of water to be administered. 
%startAn is starting animal (string)
%stopAn is stop animal (string)
%date is a specific date one can designate

%ASM 3/9/12

function analyzeRewards(date,totalWater, startAn, stopAn)

%change to data directory
origDir = cd('D:\DATA\Ari\Current Mice');

%Amount dispensed 
singleWater = 4; % in uL

%Get list of folders in directory
folderList = dir('AM*'); 
for i=1:size(folderList,1) %convert string of last 3 characters (nums) into double in anNum array 
    anNum(i,1) = str2double(folderList(i).name(3:5));
end
if exist('startAn')
    startAn = str2double(startAn(3:5)); %convert start and stop into array if they exist
end
if exist('stopAn')
    stopAn = str2double(stopAn(3:5));
end


warning('off','MATLAB:load:variableNotFound')
%if inputs are empty, designate them as lowest and highest values
if nargin < 4
    stopAn = max(anNum);
end
if nargin < 3
    startAn = min(anNum);
end
if nargin < 2
    totalWater = 800;
end
if nargin < 1
    date = datestr(now,'yymmdd');
end
data = [];
%Go to each file from the current date and compare
for i=1:size(folderList,1)
    if str2double(folderList(i).name(3:5)) < startAn || str2double(folderList(i).name(3:5)) > stopAn
        continue;
    end
    noData = false;
    rootDir = cd(folderList(i).name); %change to directory
    fileList = what;
    findResult = fileList.mat(cell2mat(cellfun(@(x) ~isempty(x),strfind(fileList.mat,date),'UniformOutput',false)));
    findResult = findResult(cell2mat(cellfun(@(x) isempty(x),strfind(findResult,'Cell'),'UniformOutput',false)));
    numRewards = 0;
    rewReceived = 0;
    for j=1:size(findResult,1)
        try
            load(findResult{j},'data'); %load that file
             numRewards = numRewards + sum(data(8,data(8,:) == floor(data(8,:))));
            rewReceived = rewReceived + sum(data(8,:) ~= 0);
            clear data;
        catch err
            noData = true;
        end
    end
    
    if noData
        disp([folderList(i).name,'  NO DATA FILE PRESENT']);
    else
        waterDisp = numRewards*singleWater;
        waterToGive = totalWater - waterDisp;
        if find(cellfun(@(x) ~isempty(x), findResult)) ~= 0
            disp([folderList(i).name,'   Water To Give: ',num2str(waterToGive),...
                'uL   Water Dispensed: ', num2str(waterDisp),...
                'uL  Rewards received: ', num2str(rewReceived)]);
        end
    end
    cd(rootDir);
end

%change back to original directory
cd(origDir);
end