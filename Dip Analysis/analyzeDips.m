function [procDip] = analyzeDips(anStr,curr)
%analyzeDips.m Analyzes whether strings of trials previous to dips affect
%the onset of a dip. 
%
%ASM 11/4/12

if curr
    pathStr = ['C:\Data\Ari\Current Mice\',anStr];
else
    pathStr = ['C:\Data\Ari\Archived Mice\',anStr];
end
oldDir = cd(pathStr); %change to animal directory

fileList = dir('AM*Cell.mat'); %list all cell files

totDips = 0; %initialize totDips
ind = 1;
indDiff = 1;
prevDir = [];
prevCol = [];
dipDir = [];
dipCol = [];
procDip.trialsBetween = [];
procDip.numDipsPer = zeros(1,length(fileList));
procDip.dipLengths = [];
procDip.rewBet = [];
procDip.biasDir = [];
procDip.biasCol = [];

for i=1:length(fileList) %for each file
    load(fileList(i).name); %load file
    if exist('dataCell') ~= 1 %#ok<EXIST> %if file didn't contain dataCell
        continue;
    end
    
    [dipInfo,dipStartsTrials,dipLengths,rewBet] = findDips(dataCell); %run findDips
    if isempty(dipInfo)
        continue;
    end
    totDips = totDips + length(dipInfo);
    procDip.numDipsPer(i) = length(dipInfo);
    procDip.dipLengths(1,size(procDip.dipLengths,2)+1:size(procDip.dipLengths,2)+procDip.numDipsPer(i)) =...
        dipLengths;
    procDip.rewBet(1,size(procDip.rewBet,2)+1:size(procDip.rewBet,2)+procDip.numDipsPer(i)) =...
        rewBet;
    
    procDip.biasDir = cat(2,procDip.biasDir,cellfun(@(x) x.biasDir,dipInfo));
    procDip.biasCol = cat(2,procDip.biasCol,cellfun(@(x) x.biasCol,dipInfo));
    
    for j=1:length(dipInfo) %for each dip in the file
        procDip.prevDir(ind) = sum(getCellVals(dipInfo{j}.prevTrials,'maze.leftTrial'))/length(dipInfo{j}.prevTrials);
        procDip.prevCol(ind) = sum(getCellVals(dipInfo{j}.prevTrials,'maze.whiteTrial'))/length(dipInfo{j}.prevTrials);
        procDip.dipDir(ind) = sum(getCellVals(dipInfo{j}.dipTrials,'result.leftTurn'))/length(dipInfo{j}.dipTrials);
        procDip.dipCol(ind) = sum(getCellVals(dipInfo{j}.dipTrials,'result.whiteTurn'))/length(dipInfo{j}.dipTrials);
        procDip.prevDirRew(ind) = sum(getCellVals(dipInfo{j}.prevRewTrials,'maze.leftTrial'))/length(dipInfo{j}.prevRewTrials);
        procDip.prevColRew(ind) = sum(getCellVals(dipInfo{j}.prevRewTrials,'maze.whiteTrial'))/length(dipInfo{j}.prevRewTrials);
        ind = ind + 1;
    end
    
    for j=2:length(dipInfo) %get time differences and trial differences between dips
        timeMat = dipInfo{j}.dipTrials{1}.time.start - dipInfo{j-1}.dipTrials{1}.time.start;
        procDip.timeBetween(indDiff) = 3600*hour(timeMat) + 60*minute(timeMat) + second(timeMat);
        indDiff = indDiff + 1;
    end
    procDip.trialsBetween(1,size(procDip.trialsBetween,2)+1:size(procDip.trialsBetween,2)+...
        length(dipStartsTrials)-1) = diff(dipStartsTrials);
end

figure('Name',[anStr,': Previous Trials Correlations']);
subplot(2,2,1);
scatter(procDip.prevDir,procDip.dipDir);
title('Direction');
xlabel('Previous Trial Left %');
ylabel('Dip Turns Left %');

subplot(2,2,2);
scatter(procDip.prevCol,procDip.dipCol);
title('Color');
xlabel('Previous Trial White %');
ylabel('Dip Turns White %');

subplot(2,2,3);
scatter(procDip.prevDirRew,procDip.dipDir);
title('Direction');
xlabel('Previous Rewarded Trial Left %');
ylabel('Dip Turns Left %');

subplot(2,2,4);
scatter(procDip.prevColRew,procDip.dipCol);
title('Color');
xlabel('Previous Rewarded Trial White %');
ylabel('Dip Turns White %');

figure('Name',[anStr,': Timing']);
subplot(1,3,1);
hist(procDip.timeBetween);
title('Time Between Dip Onsets');
xlabel('Time(s)');
ylabel('Count');

subplot(1,3,2);
hist(procDip.trialsBetween);
title('Trials Between Dip Onsets');
xlabel('Number of Trials');
ylabel('Count');

subplot(1,3,3);
hist(procDip.rewBet(~isnan(procDip.rewBet)));
title('Rewards Between Dip Onsets');
xlabel('Number of Rewards');
ylabel('Count');

figure('Name',[anStr,': Number of Dips Per Session']);
hist(procDip.numDipsPer,max(procDip.numDipsPer)+1);
title('Dips Per Session Distribution');
xlabel('Number of Dips');
ylabel('Count');
set(gca,'XTick',0:max(procDip.numDipsPer));

figure('Name',[anStr,': Dip Lengths']);
hist(procDip.dipLengths);
title('Dips Lengths Distribution');
xlabel('Dip Duration (Windows)');
ylabel('Count');
end
        
