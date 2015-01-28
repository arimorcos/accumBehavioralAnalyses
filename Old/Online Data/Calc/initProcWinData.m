%initProcWinData.m

%function to initialize process window data

%ASM 6/15/12

function [procWinData] = initProcWinData(data,sessionTime,winSize,guiID)
    procWinData.winRewards = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winTrials = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winPercRewards = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winLefts = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winPercLeft = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winFracLeft = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winPercWhite = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.winFracWhite = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    procWinData.maxK = 1;
    procWinData.totTime = 0;
    
    if guiID == 2
        procWinData.winRewardsTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
        procWinData.winRewardsNoTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
        procWinData.winTrialsTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
        procWinData.winTrialsNoTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
        procWinData.winPercRewardsTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
        procWinData.winPercRewardsNoTower = zeros(1,floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))));
    end
    if guiID == 3 || guiID == 4
        procWinData.delayInd = [];
    end
end