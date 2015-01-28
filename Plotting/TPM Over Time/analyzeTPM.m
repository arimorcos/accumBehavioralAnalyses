function [tpm, dates, mazeLength] = analyzeTPM(startAn,stopAn,ballChange,startDate,stopDate,currArch)
%analyzeTPM.m Plot trials per minute over time with markers specifying ball
%change dates
%
%startAn - string of first animal's name ex. 'AM060'
%stopAn - string of last animal's name
%ballChange - string or cell array of ball change dates
%startDate - string of start date in format yymmdd ex. '130512'
%stopDate - string of stop date in format yymmdd
%currArch - boolean of current or archived. If current, true
%
%ASM 7/13

if nargin<6; currArch = true; end

%specify root directory
if currArch
    mouseDir = 'D:\Data\Ari\Current Mice';
else
    mouseDir = 'D:\Data\Ari\Archived Mice';
end
initials = 'AM';


%change to dir
origDir = cd(mouseDir);

%get mouse names
allMice = dir([initials,'*']);

%cull list to only include animals in between start and stop
ind = 1;
for i=1:length(allMice) %for each mouse
    mNum = str2double(allMice(i).name(3:5));
    if mNum >= str2double(startAn(3:5)) && mNum <= str2double(stopAn(3:5))
        mouseList{ind} = allMice(i).name;
        ind = ind + 1;
    end
end

%get trials per minute for each day
tpm = cell(1,length(mouseList));
dates = cell(1,length(mouseList));
mazeLength = cell(1,length(mouseList));
for i=1:length(mouseList) %for each culled mouse
    
    [tpm{i}, dates{i}, mazeLength{i}] = getTPM(mouseList{i},mouseDir,startDate,stopDate);
    
end

%change back to origDir
cd(origDir);

%plot
plotTPM(ballChange,tpm,dates,mazeLength,mouseList);
end