%processData.m

%function to take in data array and calculate - 


%ASM 6/13/12

function [procData] = processData(data,exper,guiID)
    
    %get leftMazes and whiteMazes from exper
    [leftMazes] = getLeftMazes(exper);
    [whiteMazes] = getWhiteMazes(exper);
    
    %get trial start/end indices and times
    [trialTimes] = getTrialStartEndTimes(data);
    
    %calculate total number of completed trials and rewards
    procData.nTrials = size(trialTimes.trialEndTimesIndex,2);
    procData.nRewards = sum(data(8,:) ~= 0);
    procData.nRewardsRec = sum(data(8,trialTimes.trialEndTimesIndex+1)==floor(data(8,trialTimes.trialEndTimesIndex+1))...
        & data(8,trialTimes.trialEndTimesIndex+1) ~= 0);
    
    %calculate total number of trials and rewards for each condition
    [procData.nTrialsConds] = calcnTrialsConds(data,trialTimes,leftMazes);
    [procData.nRewConds] = calcnRewConds(data,leftMazes);
    
    %calculate total percent correct total and for each condition
    procData.percCorr = 100*procData.nRewards/procData.nTrials;
    procData.percCorrConds = 100*(procData.nRewConds./procData.nTrialsConds);
    procData.fracCorr = procData.nRewards/procData.nTrials;
    
    %calculate total percent left and percent white
    [procData.percLeft] = calcPercLeft(leftMazes,procData.nTrialsConds,procData.nRewConds);
    [procData.percWhite] = calcPercWhite(whiteMazes,procData.nTrialsConds,procData.nRewConds);
    
    %calculate total mean +- std trial duration
    [procData.meanTrialDur procData.stdTrialDur] = calcTrialDur(trialTimes);
    
    %calculate sessionTime
    procData.sessionTimeVector = data(1,end)-data(1,1);
    [procData.sessionTime] = calcSessionTime(data);
    
    %calculate total trials/rewards per minute
    procData.trialsPerMin = procData.nTrials/procData.sessionTime;
    procData.rewPerMin = procData.nRewards/procData.sessionTime;
    
    %get turnList
    [procData.turnList] = getTurnList(data,leftMazes,whiteMazes,trialTimes);
    
    %get results for shuffle
    procData.results(1,:) = procData.turnList(4,:);
    procData.results(2,:) = procData.turnList(2,:);
    
    procData.trialTimes = trialTimes;
    
    %get list of trials with times
    procData.trialList = [];
    procData.trialList(1,:) = trialTimes.trialEndTimesIndex;
    procData.trialList(2,:) = data(7,trialTimes.trialEndTimesIndex);
    procData.totTime = size(data,2);
    
    %generate time vector
    procData.plotTimes = data(1,:) - data(1,1);
    
    %calculate paired data
    if guiID == 2
        [pairedData] = processPaired(data,leftMazes,whiteMazes,procData,trialTimes);
        procData = catstruct(procData,pairedData);
    end
    
    %calculate delay data
    if guiID == 3 || guiID == 4
        procData.whichDelays = unique(data(10,:));
        [delayData] = processGradedDelay(data,leftMazes,whiteMazes);
        procData.delayData = delayData;
    end
    
    %get scaleFac
    if guiID == 4
        procData.scaleFacCurr = data(11,end);
        procData.scaleFacAll = data(11,:);
        if size(data,1) >= 12
            procData.lengthFacCurr = data(12,end);
            procData.lengthFacAll = data(12,:);
        else
            procData.lengthFacCurr = NaN;
            procData.lengthFacAll = nan(size(data(11,:)));
        end
        [procData.scaleFacQuarts] = calcScaleFacQuarts(data,trialTimes);
    end 
    
    %get greyFac
    if guiID == 5
        procData.greyFac = data(10,end);
        procData.greyFacAll = data(10,:);
    end
    
end