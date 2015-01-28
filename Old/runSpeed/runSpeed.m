%runSpeed.m

%function to analyze the running speed of the mouse through various
%components of the maze and determine time of cue period and delay period 

%ASM 6/26/12

function [runData] = runSpeed(data,cueLength,delayLength,turnLength)
   
    %get times of trial start and end
    [times] = getTrialStartEndTimes(data);
    
    %convert cue, delay and turn to absolute y ranges
    cueY = [1 cueLength];
    delayY = [cueLength cueLength + delayLength];
    turnY = [cueLength + delayLength cueLength + delayLength + turnLength];
    
    cueTime = zeros(1,length(times.trialEndTimesIndex));
    delayTime = zeros(1,length(times.trialEndTimesIndex));
    turnTime = zeros(1,length(times.trialEndTimesIndex));
    
    for i=1:length(times.trialEndTimesIndex)
       indexValues = times.trialStartTimesIndex(i):times.trialEndTimesIndex(i);
       cueIndex(1) = indexValues(find(data(3,indexValues) >= cueY(1),1,'first'));
       cueIndex(2) = indexValues(find(data(3,indexValues)<=cueY(2),1,'last'));
       delayIndex(1) = indexValues(find(data(3,indexValues) >= delayY(1),1,'first'));
       delayIndex(2) = indexValues(find(data(3,indexValues)<=delayY(2),1,'last'));
       turnIndex(1) = indexValues(find(data(3,indexValues) >= turnY(1),1,'first'));
       turnIndex(2) = indexValues(find(data(3,indexValues)<=turnY(2),1,'last'));
       
       cueTime(i) = data(1,cueIndex(2)) - data(1,cueIndex(1));
       delayTime(i) = data(1,delayIndex(2)) - data(1,delayIndex(1));
       turnTime(i) = data(1,turnIndex(2)) - data(1,turnIndex(1));
    end
    
    [runData.cueTimeSecs] = dnum2secs(cueTime);
    [runData.delayTimeSecs] = dnum2secs(delayTime);
    [runData.turnTimeSecs] = dnum2secs(turnTime);
    
    runData.cueMean = mean(runData.cueTimeSecs);
    runData.delayMean = mean(runData.delayTimeSecs);
    runData.turnMean = mean(runData.turnTimeSecs);
    
    runData.cueMedian = median(runData.cueTimeSecs);
    runData.delayMedian = median(runData.delayTimeSecs);
    runData.turnMedian = median(runData.turnTimeSecs);
    
    runData.cueSTD = std(runData.cueTimeSecs);
    runData.delaySTD = std(runData.delayTimeSecs);
    runData.turnSTD = std(runData.turnTimeSecs);
end