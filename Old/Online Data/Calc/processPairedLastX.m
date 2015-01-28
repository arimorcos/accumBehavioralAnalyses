%processPairedLastX.m

%function to calculate the statistics for the paired configuration

%ASM 6/14/12

function [pairedData] = processPairedLastX(data,leftMazes,whiteMazes,procData,trialTimesLastX)
    
    %Calculate nTrials Tower and No Tower
    pairedData.nTrialsTowerLastX = sum(procData.nTrialsCondsLastX(1:2:7));
    pairedData.nTrialsNoTowerLastX = sum(procData.nTrialsCondsLastX(2:2:8));
    
    %Calculate nRewards Tower and No Tower 
    pairedData.nRewTowerLastX = sum(procData.nRewCondsLastX(1:2:7));
    pairedData.nRewNoTowerLastX = sum(procData.nRewCondsLastX(2:2:8));
    
    %Calculate percent correct Tower and No Tower
    pairedData.percCorrTowerLastX = 100*pairedData.nRewTowerLastX/pairedData.nTrialsTowerLastX;
    pairedData.percCorrNoTowerLastX = 100*pairedData.nRewNoTowerLastX/pairedData.nTrialsNoTowerLastX;
    
    %Calculate percent left and white Tower and No Tower
    [pairedData.percLeftTowerLastX pairedData.percLeftNoTowerLastX] = calcPercLeftPaired(leftMazes,procData.nTrialsCondsLastX,procData.nRewCondsLastX);
    [pairedData.percWhiteTowerLastX pairedData.percWhiteNoTowerLastX] = calcPercWhitePaired(whiteMazes,procData.nTrialsCondsLastX,procData.nRewCondsLastX);
    
    %calculate fraction left and white tower and no tower
    towerMazes = zeros(size(leftMazes));
    towerMazes(1:2:7) = 1;
    noTowerMazes = ones(size(leftMazes))-towerMazes;
    pairedData.fracLeftTowerLastX = sum(procData.nTrialsCondsLastX(leftMazes == 1 & towerMazes == 1));
    pairedData.fracLeftNoTowerLastX = sum(procData.nTrialsCondsLastX(leftMazes == 1 & noTowerMazes == 1));
    pairedData.fracWhiteTowerLastX = sum(procData.nTrialsCondsLastX(whiteMazes == 1 & towerMazes == 1));
    pairedData.fracWhiteNoTowerLastX = sum(procData.nTrialsCondsLastX(whiteMazes == 1 & noTowerMazes == 1));
    
    %Calculate trials and rewards per minute Tower and No Tower
    [timeTowerLastX timeNoTowerLastX] = calcPairedTrialTimes(data,trialTimesLastX);
    pairedData.trialsPerMinTowerLastX = pairedData.nTrialsTowerLastX/timeTowerLastX;
    pairedData.rewardsPerMinTowerLastX = pairedData.nRewTowerLastX/timeTowerLastX;
    pairedData.trialsPerMinNoTowerLastX = pairedData.nTrialsNoTowerLastX/timeNoTowerLastX;
    pairedData.rewardsPerMinNoTowerLastX = pairedData.nRewNoTowerLastX/timeNoTowerLastX;
    
    %calculate mean +- std trial duration for tower and no tower
    [pairedData.meanDurTowerLastX pairedData.stdDurTowerLastX pairedData.meanDurNoTowerLastX pairedData.stdDurNoTowerLastX]...
        = calcPairedMeanStd(data,trialTimesLastX);
    
end