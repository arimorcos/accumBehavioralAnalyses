%processGradedDelay.m

%function to process information from the graded delay maze

%ASM 6/14/12

function [delayData] = processGradedDelay(data,leftMazes,whiteMazes)
    
    %determine the number of unique conditions
    [delaySort(:,1) delaySort(:,2)] = unique(data(10,:));
    delaySort = sortrows(delaySort,2);
    whichDelays = delaySort(:,1)';
    
    %create loop for each condition
    for i=1:length(whichDelays)
        
        delayData(i).delay = whichDelays(i); %#ok<*AGROW>
        
        %get trial start/end times for delay condition
        [times(i)] = getTrialStartEndTimesDelay(data,whichDelays(i));
        
        %calculate total number of completed trials and rewards
        delayData(i).nTrials = size(times(i).trialEndTimesIndex,2);
        delayData(i).nRewards = sum(data(8,data(10,:)==whichDelays(i))~=0);
        
        %calculate total number of trials and rewards for each condition
        [delayData(i).nTrialsConds] = calcnTrialsConds(data,times(i),leftMazes);
        [delayData(i).nRewConds] = calcnRewCondsDelay(data,leftMazes,whichDelays(i));
        
        %calculate total percent correct total and for each condition
        delayData(i).percCorr = 100*delayData(i).nRewards/delayData(i).nTrials;
        delayData(i).percCorrConds = 100*(delayData(i).nRewConds./delayData(i).nTrialsConds);
        
        %calculate total percent left and percent white
        [delayData(i).percLeft] = calcPercLeft(leftMazes,delayData(i).nTrialsConds,delayData(i).nRewConds);
        [delayData(i).percWhite] = calcPercWhite(whiteMazes,delayData(i).nTrialsConds,delayData(i).nRewConds);
        
        %calculate total mean +- std trial duration
        [delayData(i).meanTrialDur delayData(i).stdTrialDur] = calcTrialDur(times(i));
        
        %calculate sessionTime
        [delayData(i).sessionTime] = calcSessionTimeDelay(times(i),data);
        
        %calculate total trials/rewards per minute
        delayData(i).trialsPerMin = delayData(i).nTrials/delayData(i).sessionTime;
        delayData(i).rewPerMin = delayData(i).nRewards/delayData(i).sessionTime;
        
        
    end

end