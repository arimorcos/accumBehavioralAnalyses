%getLastXTimes.m

%function to cull trialTimes to only the last x trials

%ASM 6/13/12

function [timesLastX] = getLastXTimes(times,data,lastX)
        
        timesLastX.trialEndTimesIndex = times.trialEndTimesIndex(end-lastX+1:end);
        timesLastX.trialStartTimesIndex = times.trialStartTimesIndex(end-lastX+1:end);

        timesLastX.trialStartTimes = data(1,timesLastX.trialStartTimesIndex);
        timesLastX.trialEndTimes = data(1,timesLastX.trialEndTimesIndex); 
    
end