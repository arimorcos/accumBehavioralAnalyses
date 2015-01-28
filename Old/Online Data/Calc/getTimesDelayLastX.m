%getTimesDelayLastX.m

%function to get the lastX trial information

%ASM 6/19/12

function [times] = getTimesDelayLastX(data,timesLastX,delayValue)
    
    times.trialEndTimesIndex = timesLastX.trialEndTimesIndex(data(10,timesLastX.trialEndTimesIndex) == delayValue);
    times.trialStartTimesIndex = timesLastX.trialStartTimesIndex(data(10,timesLastX.trialStartTimesIndex) == delayValue);

    times.trialStartTimes = data(1,times.trialStartTimesIndex);
    times.trialEndTimes = data(1,times.trialEndTimesIndex);
end