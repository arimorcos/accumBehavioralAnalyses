%calcTrialDur.m

%function to calculate the trial duration and std of a given session

%ASM 6/13/12

function [meanDur stdDur] = calcTrialDur(times)
    
        trialDur = times.trialEndTimes - times.trialStartTimes;
        
        for k = 1:size(trialDur,2) %convert to seconds
            [H M S MS] = strread(datestr(trialDur(k),'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
            trialDur(k) = 3600*H + 60*M + S + MS/1000; 
        end

        meanDur = mean(trialDur);
        stdDur = std(trialDur);
end