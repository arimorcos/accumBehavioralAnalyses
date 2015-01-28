%processGradedLastX.m

%function to calculate the statistics for the Graded configuration

%ASM 6/14/12

function [gradedData] = processGradedLastX(data,leftMazes,whiteMazes,procData,trialTimesLastX)
    
     %determine number of delays
     [delaySort(:,1) delaySort(:,2)] = unique(data(10,:));
     delaySort = sortrows(delaySort,2);
     whichDelaysAll = delaySort(:,1)';
     whichDelays = unique(data(10,trialTimesLastX.trialEndTimesIndex(1):trialTimesLastX.trialEndTimesIndex(end)));
     
     for i=1:length(whichDelaysAll)
         if ismember(whichDelaysAll(i),whichDelays)
            %get trial times which are in delay condition
            [timesDelay(i)] = getTimesDelayLastX(data,trialTimesLastX,whichDelaysAll(i));

            %calculate total number of completed trials and rewards
            gradedData(i).nTrials = size(timesDelay(i).trialEndTimesIndex,2); %#ok<*AGROW>
            gradedData(i).nRewards = sum(data(8,timesDelay(i).trialEndTimesIndex(data(10,timesDelay(i).trialEndTimesIndex)==whichDelaysAll(i))+1)~=0);

            %calculate total number of trials and rewards for each condition
            [gradedData(i).nTrialsConds] = calcnTrialsConds(data,timesDelay(i),leftMazes);
            [gradedData(i).nRewConds] = calcnRewCondsDelayLastX(data,leftMazes,timesDelay(i),whichDelaysAll(i));

            %calculate total percent correct total and for each condition
            gradedData(i).percCorr = 100*gradedData(i).nRewards/gradedData(i).nTrials;
            gradedData(i).percCorrConds = 100*(gradedData(i).nRewConds./gradedData(i).nTrialsConds);

            %calculate total percent left and percent white
            [gradedData(i).percLeft] = calcPercLeft(leftMazes,gradedData(i).nTrialsConds,gradedData(i).nRewConds);
            [gradedData(i).percWhite] = calcPercWhite(whiteMazes,gradedData(i).nTrialsConds,gradedData(i).nRewConds);

            %calculate total mean +- std trial duration
            [gradedData(i).meanTrialDur gradedData(i).stdTrialDur] = calcTrialDur(timesDelay(i));

            %calculate sessionTime
            [gradedData(i).sessionTime] = calcSessionTimeDelay(timesDelay(i),data);

            %calculate total trials/rewards per minute
            gradedData(i).trialsPerMin = gradedData(i).nTrials/gradedData(i).sessionTime;
            gradedData(i).rewPerMin = gradedData(i).nRewards/gradedData(i).sessionTime;
         else
            gradedData(i).nTrials = 0;
            gradedData(i).nRewards = 0;
            gradedData(i).nTrialsConds = zeros(length(procData.nTrialsConds),1);
            gradedData(i).nRewConds = zeros(length(procData.nTrialsConds),1);
            gradedData(i).percCorr = NaN;
            gradedData(i).percCorrConds = nan(length(procData.nTrialsConds),1);
            gradedData(i).percLeft = NaN;
            gradedData(i).percWhite = NaN;
            gradedData(i).meanTrialDur = NaN;
            gradedData(i).stdTrialDur = NaN;
            gradedData(i).sessionTime = NaN;
            gradedData(i).trialsPerMin = NaN;
            gradedData(i).rewPerMin = NaN;
         end
     end
end