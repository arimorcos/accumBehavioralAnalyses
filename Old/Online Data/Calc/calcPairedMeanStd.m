%calcPairedMeanStd.m

%function to calculate the mean and std of trial duration for tower/no
%tower

%ASM 6/14/12

function [meanDurTower stdDurTower meanDurNoTower stdDurNoTower] = calcPairedMeanStd(data,times)
    
        towerEndTimes = data(mod(data(7,times.trialEndTimesIndex),2) == 1);
        towerStartTimes = data(mod(data(7,times.trialStartTimesIndex),2) == 1);
        noTowerEndTimes = data(mod(data(7,times.trialEndTimesIndex),2) == 0);
        noTowerStartTimes = data(mod(data(7,times.trialStartTimesIndex),2) == 0);
        
        trialDurTower = towerEndTimes - towerStartTimes;
        trialDurNoTower = noTowerEndTimes - noTowerStartTimes;
        
        for k = 1:size(trialDurTower,2) %convert to seconds
            [H M S MS] = strread(datestr(trialDurTower(k),'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
            trialDurTower(k) = 3600*H + 60*M + S + MS/1000; 
        end
        for k = 1:size(trialDurNoTower,2) %convert to seconds
            [H M S MS] = strread(datestr(trialDurNoTower(k),'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
            trialDurNoTower(k) = 3600*H + 60*M + S + MS/1000; 
        end

        meanDurTower = mean(trialDurTower);
        meanDurNoTower = mean(trialDurNoTower);
        stdDurTower = std(trialDurTower);
        stdDurNoTower = std(trialDurNoTower);
end