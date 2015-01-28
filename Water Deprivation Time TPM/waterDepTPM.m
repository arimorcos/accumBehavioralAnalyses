function [waterDep, TPM] = waterDepTPM(anName,mouseDir)
%timeTPMCorr.m function to perform correlation between current day trials
%per minute and previous days total run time. anName is a string input,
%currArch is a binary signifying whether the folder is in current or
%archived (0 - current, 1 - archived) while time and TPM are row vectors
%containing the previous day trial times (in minutes) and the trials per
%minute for the test day.

fullAnDir = fullfile(mouseDir,anName);

%throw error if directory doesn't exist
if exist(fullAnDir,'dir') == 0
    error('Folder does not exist');
end

%move to directory
origDir = cd(fullAnDir);

%get list of all cell files
cellFiles = dir('*Cell*.mat');

%initialize arrays
tTrials = zeros(1,length(cellFiles));
TPM = zeros(1,length(cellFiles));
waterDep = zeros(1,length(cellFiles));

%load each cell file and get tpm, total trials and session time
for i=1:length(cellFiles) %for each file
    
    
    load(cellFiles(i).name); %load file
   
    if i==1
        day1 = dataCell{1}.time.sessionStart;
    end
    
    tempTime = dataCell{end}.time.stop - dataCell{1}.time.start; %get total session time
    time = convertToMin(tempTime);
    
    waterDep(i) = daysact(day1,dataCell{1}.time.sessionStart);
    
    tTrials(i) = length(dataCell); %get total trials
    
    TPM(i) = tTrials(i)/time; %get trials per minute
    
end

%filter out sessions with less than 30 trials
% waterDep = waterDep(tTrials >= 30);
% TPM = TPM(tTrials >= 30);

%remove mice with fewer than five points
if length(TPM) < 5
    TPM = NaN;
    waterDep = NaN;
end

%switch back to original directory
cd(origDir);
end

function out = convertToMin(in)
%converts date time to total minutes

out = 60*hour(in) + minute(in) + second(in)/60;

end