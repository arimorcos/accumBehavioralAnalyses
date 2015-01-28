%processPaired.m

%function to calculate the statistics for the paired configuration

%ASM 6/14/12

function [pairedData] = processPaired(data,leftMazes,whiteMazes,procData,trialTimes)
    
    %Calculate nTrials Tower and No Tower
    pairedData.nTrialsTower = sum(procData.nTrialsConds(1:2:7));
    pairedData.nTrialsNoTower = sum(procData.nTrialsConds(2:2:8));
    
    %Calculate nRewards Tower and No Tower 
    pairedData.nRewTower = sum(procData.nRewConds(1:2:7));
    pairedData.nRewNoTower = sum(procData.nRewConds(2:2:8));
    
    %Calculate percent correct Tower and No Tower
    pairedData.percCorrTower = 100*pairedData.nRewTower/pairedData.nTrialsTower;
    pairedData.percCorrNoTower = 100*pairedData.nRewNoTower/pairedData.nTrialsNoTower;
    
    %Calculate percent left and white Tower and No Tower
    [pairedData.percLeftTower pairedData.percLeftNoTower] = calcPercLeftPaired(leftMazes,procData.nTrialsConds,procData.nRewConds);
    [pairedData.percWhiteTower pairedData.percWhiteNoTower] = calcPercWhitePaired(whiteMazes,procData.nTrialsConds,procData.nRewConds);
    
    %calculate fraction left and white tower and no tower
    towerMazes = zeros(size(leftMazes));
    towerMazes(1:2:7) = 1;
    noTowerMazes = ones(size(leftMazes))-towerMazes;
    pairedData.fracLeftTower= sum(procData.nTrialsConds(leftMazes == 1 & towerMazes == 1));
    pairedData.fracLeftNoTower= sum(procData.nTrialsConds(leftMazes == 1 & noTowerMazes == 1));
    pairedData.fracWhiteTower= sum(procData.nTrialsConds(whiteMazes == 1 & towerMazes == 1));
    pairedData.fracWhiteNoTower= sum(procData.nTrialsConds(whiteMazes == 1 & noTowerMazes == 1));
    
    %Calculate trials and rewards per minute Tower and No Tower
    [timeTower timeNoTower] = calcPairedTrialTimes(data,trialTimes);
    pairedData.trialsPerMinTower = pairedData.nTrialsTower/timeTower;
    pairedData.rewardsPerMinTower = pairedData.nRewTower/timeTower;
    pairedData.trialsPerMinNoTower = pairedData.nTrialsNoTower/timeNoTower;
    pairedData.rewardsPerMinNoTower = pairedData.nRewNoTower/timeNoTower;
    
    %calculate mean +- std trial duration for tower and no tower
    [pairedData.meanDurTower pairedData.stdDurTower pairedData.meanDurNoTower pairedData.stdDurNoTower] = calcPairedMeanStd(data,trialTimes);
    
end