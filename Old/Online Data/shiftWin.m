%shiftWin.m

%function to shift data so that 5 minute delay is at end 

function [data xTimes] = shiftWin(data,xTimes,guiID)
    
    shiftSize = data.totTime - length(data.winRewards);
    
    xTimes = xTimes + shiftSize;
    
    %add NaNs
    data.winRewards(end+1:end+shiftSize) = NaN;
    data.winTrials(end+1:end+shiftSize) = NaN;
    data.winPercRewards(end+1:end+shiftSize) = NaN;
    data.winLefts(end+1:end+shiftSize) = NaN;
    data.winPercLeft(end+1:end+shiftSize) = NaN;
    data.winFracLeft(end+1:end+shiftSize) = NaN;
    data.winPercWhite(end+1:end+shiftSize) = NaN;
    data.winFracWhite(end+1:end+shiftSize) = NaN;
    xTimes(end+1:end+shiftSize) = NaN;
    
    %shift
    data.winRewards = circshift(data.winRewards,[0 shiftSize]);
    data.winTrials = circshift(data.winTrials,[0 shiftSize]);
    data.winPercRewards = circshift(data.winPercRewards,[0 shiftSize]);
    data.winLefts = circshift(data.winLefts,[0 shiftSize]);
    data.winPercLeft = circshift(data.winPercLeft,[0 shiftSize]);
    data.winFracLeft = circshift(data.winFracLeft,[0 shiftSize]);
    data.winPercWhite = circshift(data.winPercWhite,[0 shiftSize]);
    data.winFracWhite = circshift(data.winFracWhite,[0 shiftSize]);
    xTimes = circshift(xTimes,[0 shiftSize]);
    
    if guiID == 2
        data.winRewardsTower(end+1:end+shiftSize) = NaN;
        data.winRewardsNoTower(end+1:end+shiftSize) = NaN;
        data.winPercRewardsTower(end+1:end+shiftSize) = NaN;
        data.winPercRewardsNoTower(end+1:end+shiftSize) = NaN;
        data.winTrialsTower(end+1:end+shiftSize) = NaN;
        data.winTrialsNoTower(end+1:end+shiftSize) = NaN;
        
        data.winRewardsTower = circshift(data.winRewardsTower,[0 shiftSize]);
        data.winRewardsNoTower = circshift(data.winRewardsNoTower,[0 shiftSize]);
        data.winPercRewardsTower = circshift(data.winPercRewardsTower,[0 shiftSize]);
        data.winPercRewardsNoTower = circshift(data.winPercRewardsNoTower,[0 shiftSize]);
        data.winTrialsTower = circshift(data.winTrialsTower,[0 shiftSize]);
        data.winTrialsNoTower = circshift(data.winTrialsNoTower,[0 shiftSize]);
    end

end