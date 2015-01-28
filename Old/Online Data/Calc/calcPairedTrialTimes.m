%calcPairedTrialTimes.m

%function to calculate the amount of time in minutes spent in the Tower and
%no tower conditions 

%ASM 6/14/12

function [timeTower timeNoTower] = calcPairedTrialTimes(data,times)

    towerEndTimes = data(1,times.trialEndTimesIndex(mod(data(7,times.trialEndTimesIndex),2) == 1));
    towerStartTimes = data(1,times.trialStartTimesIndex(mod(data(7,times.trialStartTimesIndex),2) == 1));
    noTowerEndTimes = data(1,times.trialEndTimesIndex(mod(data(7,times.trialEndTimesIndex),2) == 0));
    noTowerStartTimes = data(1,times.trialStartTimesIndex(mod(data(7,times.trialStartTimesIndex),2) == 0));
    
    towerTimeVec = sum(towerEndTimes - towerStartTimes);
    noTowerTimeVec = sum(noTowerEndTimes - noTowerStartTimes);

    [H M S MS] = strread(datestr(towerTimeVec,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
    timeTower = 60*H + M + S/60 + MS/60000;
    
    [H M S MS] = strread(datestr(noTowerTimeVec,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
    timeNoTower = 60*H + M + S/60 + MS/60000;
        
end