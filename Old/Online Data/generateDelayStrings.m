%generateDelayStrings.m

%function to find the number of conditions and generate a cell array of
%strings for trials, rewards and percent correct

function [delayStrings] = generateDelayStrings(delays,numConds)


    for i=1:length(delays)
        delayStrings(i).trials = ['nTrials ',num2str(delays(i)),'% Delay'];
        delayStrings(i).rewards = ['nRewards ',num2str(delays(i)),'% Delay'];
        delayStrings(i).percCorr = ['Percent Correct ',num2str(delays(i)),'% Delay'];
        delayStrings(i).percLeft = ['Percent Left ',num2str(delays(i)),'% Delay'];
        delayStrings(i).percWhite = ['Percent White ',num2str(delays(i)),'% Delay'];
        delayStrings(i).trialsPerMin = ['Trials Per Minute ',num2str(delays(i)),'% Delay'];
        delayStrings(i).rewardsPerMin = ['Rewards Per Minute ',num2str(delays(i)),'% Delay'];
        
        for j=1:numConds
           trialName = ['condTrials',num2str(j)];
           rewardName = ['condRewards',num2str(j)];
           percName = ['condPercCorr',num2str(j)];
           delayStrings(i).(percName) = ['Condition ',num2str(j),' Percent Correct ',num2str(delays(i)),'% Delay'];
           delayStrings(i).(trialName) = ['Condition ',num2str(j),' Trials ',num2str(delays(i)),'% Delay'];
           delayStrings(i).(rewardName) = ['Condition ',num2str(j),' Rewards ',num2str(delays(i)),'% Delay'];
        end
        
        delayStrings(i).meanDur = ['Mean Trial Duration ',num2str(delays(i)),'% Delay'];
        delayStrings(i).stdDur = ['Std Trial Duration ',num2str(delays(i)),'% Delay'];
    end
end