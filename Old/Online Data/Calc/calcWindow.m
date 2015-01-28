%calcWindow.m

%function to calculate percent correct, percent left, and percent white over a sliding window

%ASM 6/13/12

function [procWinData] = calcWindow(data,sessionTime,winSize,times,turnList,procWinData,leftMazes,whiteMazes,guiID,checks)

if sessionTime > winSize && any(unique(structfun(@(x) x,checks)))
    for k = procWinData.maxK:(size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize))
        winTrialIndex = times.trialEndTimesIndex(times.trialEndTimesIndex >= k &...
            times.trialEndTimesIndex < (k + size(data,2)*winSize/sessionTime));
        procWinData.winRewards(k) = sum(data(8,winTrialIndex+1)~=0);
        procWinData.winTrials(k) = size(winTrialIndex,2);
        procWinData.winPercRewards(k) = 100*procWinData.winRewards(k)/procWinData.winTrials(k);
        
        %calculate tower/no tower
        if guiID == 2
            winTrialIndexTower = winTrialIndex(mod(data(7,winTrialIndex),2) == 1);
            winTrialIndexNoTower = winTrialIndex(mod(data(7,winTrialIndex),2) == 0);
            procWinData.winRewardsTower(k) = sum(data(8,winTrialIndexTower+1) ~= 0);
            procWinData.winRewardsNoTower(k) = sum(data(8,winTrialIndexNoTower+1) ~= 0);
            procWinData.winTrialsTower(k) = size(winTrialIndexTower,2);
            procWinData.winTrialsNoTower(k) = size(winTrialIndexNoTower,2);
            procWinData.winPercRewardsTower(k) = 100*procWinData.winRewardsTower(k)/procWinData.winTrialsTower(k);
            procWinData.winPercRewardsNoTower(k) = 100*procWinData.winRewardsNoTower(k)/procWinData.winTrialsNoTower(k);
        end
        
        %calculate percent left and white
        winStart = k;
        winEnd = k + size(data,2)*winSize/sessionTime;
        if ~isempty(turnList)
            procWinData.winLefts(k) = sum(turnList(2,turnList(1,:) >= winStart & turnList(1,:) < winEnd));
            procWinData.winPercLeft(k) = 100*procWinData.winLefts(k)/procWinData.winTrials(k);
            procWinData.winWhites(k) = sum(turnList(3,turnList(1,:) >= winStart & turnList(1,:) < winEnd));
            procWinData.winPercWhite(k) = 100*procWinData.winWhites(k)/procWinData.winTrials(k);
        else
            procWinData.winLefts(k) = NaN;
            procWinData.winPercLeft(k) = NaN;
            procWinData.winWhites(k) = NaN;
            procWinData.winPercWhite(k) = NaN;
        end

        %calculate fraction left and white
        numLeftTrials = sum(ismember(data(7,winTrialIndex),find(leftMazes == 1)));
        procWinData.winFracLeft(k) = 100*numLeftTrials/procWinData.winTrials(k);
        numWhiteTrials = sum(ismember(data(7,winTrialIndex),find(whiteMazes == 1)));
        procWinData.winFracWhite(k) = 100*numWhiteTrials/procWinData.winTrials(k);
        
    end
    procWinData.totTime = size(data,2);
    %calculate diffs
    if guiID == 3 || guiID == 4
        procWinData.delayInd = nan(1,50);
        diffArr = diff(data(10,:));
        procWinData.delayInd(1) = 1;
        procWinData.delayInd(2:1+length(find(diffArr~=0))) = find(diffArr ~= 0)+1;
        procWinData.delayInd(isnan(procWinData.delayInd)) = [];
        procWinData.delayInd(2,:) = data(10,procWinData.delayInd(1,:));
    end
    

else
    procWinData.winPercRewards = NaN;
    procWinData.winTrials = NaN;
    procWinData.winPercLeft = NaN;
    procWinData.totTime = size(data,2);
    procWinData.winRewardsTower = NaN;
    procWinData.winRewardsNoTower = NaN;
    procWinData.winTrialsTower = NaN;
    procWinData.winTrialsNoTower = NaN;
    procWinData.winPercRewardsTower = NaN;
    procWinData.winPercRewardsNoTower = NaN;
    procWinData.winFracLeft = NaN;
    procWinData.delayInd = NaN;
end

procWinData.maxK = floor((size(data,2)*((sessionTime/winSize)-1)/(sessionTime/winSize)));

end