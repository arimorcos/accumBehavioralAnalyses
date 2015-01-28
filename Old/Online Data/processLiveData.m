%processLiveData.m

%function to take in data array and calculate - 


%ASM 6/13/12

function [procData, winDataFlag] = processLiveData(data,exper,lastX,winSize,winData,winDataFlag,guiID,reCalcWinFlag,checks)
    
    %get leftMazes and whiteMazes from exper
    [leftMazes] = getLeftMazes(exper);
    [whiteMazes] = getWhiteMazes(exper);
    
    %get trial start/end indices and times
    [trialTimes] = getTrialStartEndTimes(data);
    
    %calculate total number of completed trials and rewards
    procData.nTrials = size(trialTimes.trialEndTimesIndex,2);
    procData.nRewards = sum(data(8,:) ~= 0);
    procData.nRewardsRec = sum(data(8,trialTimes.trialEndTimesIndex(data(8,trialTimes.trialEndTimesIndex+1)...
        ==floor(data(8,trialTimes.trialEndTimesIndex+1)))+1));
    
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
    
    %calculate fraction left and fraction white
    procData.fracLeft = sum(procData.nTrialsConds(leftMazes == 1))/procData.nTrials;
    procData.fracWhite = sum(procData.nTrialsConds(whiteMazes == 1))/procData.nTrials;
    
    %calculate total mean +- std trial duration
    [procData.meanTrialDur, procData.stdTrialDur] = calcTrialDur(trialTimes);
    
    %calculate sessionTime
    procData.sessionTimeVector = data(1,end)-data(1,1);
    [procData.sessionTime] = calcSessionTime(data);
    
    %calculate total trials/rewards per minute
    procData.trialsPerMin = procData.nTrials/procData.sessionTime;
    procData.rewPerMin = procData.nRewards/procData.sessionTime;
    
    %get turnList
    [procData.turnList] = getTurnList(data,leftMazes,whiteMazes,trialTimes);
    
    %get results for shuffle
    if size(procData.turnList,2) > 0
        procData.results(1,:) = procData.turnList(4,:);
        procData.results(2,:) = procData.turnList(2,:);
    end
    
    %calculate sliding window
    if procData.sessionTime > winSize && winDataFlag && ~reCalcWinFlag && any(unique(structfun(@(x) x,checks)))
        procData.procWinData = winData;
        [procData.procWinData] = calcWindow(data,procData.sessionTime,winSize,trialTimes,...
            procData.turnList,procData.procWinData,leftMazes,whiteMazes,guiID,checks);
        [procData.corrRes] = calcWinCorr(procData.procWinData);
    else
        [procData.procWinData] = initProcWinData(data,procData.sessionTime,winSize,guiID);
        [procData.corrRes] = initCorrRes();
        winDataFlag = true;
    end
    
    %get list of trials with times
    procData.totTime = size(data,2);
    procData.trialList = [];
    procData.trialList(1,:) = trialTimes.trialEndTimesIndex;
    procData.trialList(2,:) = data(7,trialTimes.trialEndTimesIndex);
  
    %generate time vector
    procData.plotTimes = data(1,:) - data(1,1);
    
%     if procData.sessionTime > winSize && winDataFlag && ~reCalcWinFlag && any(unique(structfun(@(x) x,checks)))
%         procData.procWinData = winData;
%         [procData.procWinData] = calcWindowFilter(data,procData.sessionTime,winSize,trialTimes,procData.turnList,procData.procWinData,leftMazes,guiID,checks);
%     else
%         [procData.procWinData] = initProcWinData(data,procData.sessionTime,winSize,guiID);
%         winDataFlag = true;
%     end
    
    %calculate paired data
    if guiID == 2
        [pairedData] = processPaired(data,leftMazes,whiteMazes,procData,trialTimes);
        procData = catstruct(procData,pairedData);
    end
    
    %calculate delay data
    if guiID == 3 || guiID == 4
        [delaySort(:,1), delaySort(:,2)] = unique(data(10,:));
        delaySort = sortrows(delaySort,2);
        procData.whichDelays = delaySort(:,1)';
        [delayData] = processGradedDelay(data,leftMazes,whiteMazes);
        procData.delayData = delayData;
    end
    
    %get scaleFac
    if guiID == 4
        procData.scaleFacCurr = data(11,end);
        procData.scaleFacAll = data(11,:);
        procData.lengthFacCurr = data(12,end);
        procData.lengthFacAll = data(12,:);
        [procData.scaleFacQuarts] = calcScaleFacQuarts(data,trialTimes);
    end 
    
    %get greyFac
    if guiID == 5
        procData.greyFac = data(10,end);
        procData.greyFacAll = data(10,:);
    end
    
    if length(trialTimes.trialEndTimesIndex) >= lastX
        %get trial start/end indices and times for last X trials
        [trialTimesLastX] = getLastXTimes(trialTimes,data,lastX);

        %calculate lastX nRewards and percCorr
        procData.nTrialsLastX = size(trialTimesLastX.trialEndTimesIndex,2);
        procData.nRewardsLastX = sum(data(8,trialTimesLastX.trialEndTimesIndex+1) ~= 0);
        procData.percCorrLastX = 100*procData.nRewardsLastX/procData.nTrialsLastX;

        %calculate lastX trials and rewards for each condition
        [procData.nTrialsCondsLastX] = calcnTrialsConds(data,trialTimesLastX,leftMazes);
        [procData.nRewCondsLastX] = calcnRewCondsLastX(data,leftMazes,trialTimesLastX);

        %calculate lastX percCorr for each condition
        procData.percCorrCondsLastX = 100*(procData.nRewCondsLastX./procData.nTrialsCondsLastX);

        %calculate lastX percLeft and percWhite
        [procData.percLeftLastX] = calcPercLeft(leftMazes,procData.nTrialsCondsLastX,procData.nRewCondsLastX);
        [procData.percWhiteLastX] = calcPercWhite(whiteMazes,procData.nTrialsCondsLastX,procData.nRewCondsLastX);
        
        %calculate fraction left and fraction white
        procData.fracLeftLastX = sum(procData.nTrialsCondsLastX(leftMazes == 1))/procData.nTrialsLastX;
        procData.fracWhiteLastX = sum(procData.nTrialsCondsLastX(whiteMazes == 1))/procData.nTrialsLastX;

        %calculate lastX mean +-std trial duration
        [procData.meanTrialDurLastX, procData.stdTrialDurLastX] = calcTrialDur(trialTimesLastX);

        %calculate time of lastX trials
        [procData.elapTimeLastX, procData.elapTimeLastXVector] = calcTimeLastX(trialTimesLastX);

        %calculate lastX trials/rewards per min 
        procData.trialsPerMinLastX = procData.nTrialsLastX/procData.elapTimeLastX;
        procData.rewPerMinLastX = procData.nRewardsLastX/procData.elapTimeLastX;
        
        %calculate paired lastX 
        if guiID == 2
            [pairedDataLastX] = processPairedLastX(data,leftMazes,whiteMazes,procData,trialTimesLastX);
            procData = catstruct(procData,pairedDataLastX);
        end
        
        %calculate graded lastX
        if guiID == 3 || guiID == 4
            [gradedDataLastX] = processGradedLastX(data,leftMazes,whiteMazes,procData,trialTimesLastX);
            procData.delayDataLastX = gradedDataLastX;
        end
        
        %calculate scaleFac
        if guiID == 4
            [procData.scaleFacQuartsLastX] = calcScaleFacQuarts(data,trialTimesLastX);
        end
        
    else
        procData.nTrialsLastX = NaN;
        procData.nRewardsLastX = NaN;
        procData.nTrialsCondsLastX = nan(length(procData.nTrialsConds),1);
        procData.nRewCondsLastX = nan(length(procData.nRewConds),1);
        procData.percCorrLastX = NaN;
        procData.percCorrCondsLastX = nan(length(procData.percCorrConds),1);
        procData.percLeftLastX = NaN;
        procData.percWhiteLastX = NaN;
        procData.meanTrialDurLastX = NaN;
        procData.stdTrialDurLastX = NaN;
        procData.elapTimeLastX = NaN;
        procData.trialsPerMinLastX = NaN;
        procData.rewPerMinLastX = NaN;
        procData.elapTimeLastXVector = 0;
        if guiID == 2
            procData.nTrialsTowerLastX = NaN;
            procData.nTrialsNoTowerLastX = NaN;
            procData.nRewTowerLastX = NaN;
            procData.nRewNoTowerLastX = NaN;
            procData.percCorrTowerLastX = NaN;
            procData.percCorrNoTowerLastX = NaN;
            procData.percLeftTowerLastX = NaN;
            procData.percLeftNoTowerLastX = NaN;
            procData.percWhiteTowerLastX = NaN;
            procData.percWhiteNoTowerLastX = NaN;
            procData.trialsPerMinTowerLastX = NaN;
            procData.rewardsPerMinTowerLastX = NaN;
            procData.trialsPerMinNoTowerLastX = NaN;
            procData.rewardsPerMinNoTowerLastX = NaN;
            procData.meanDurTowerLastX = NaN;
            procData.stdDurTowerLastX = NaN;
            procData.meanDurNoTowerLastX = NaN;
            procData.stdDurNoTowerLastX = NaN;
        elseif guiID == 3 || guiID == 4
            procData.delayDataLastX(:).nTrials = NaN;
            procData.delayDataLastX(:).nRewards = NaN;
            procData.delayDataLastX(:).percCorr = NaN;
            procData.delayDataLastX(:).percLeft = NaN;
            procData.delayDataLastX(:).percWhite = NaN;
            procData.delayDataLastX(:).trialsPerMin = NaN;
            procData.delayDataLastX(:).rewPerMin = NaN;
            procData.delayDataLastX(:).percCorrConds = nan(length(procData.nTrialsConds),1);
            procData.delayDataLastX(:).nTrialsConds = nan(length(procData.nTrialsConds),1);
            procData.delayDataLastX(:).nRewConds = nan(length(procData.nTrialsConds),1);
        end
        if guiID == 4
            procData.scaleFacQuartsLastX = nan(3,5);
        end
    end
end