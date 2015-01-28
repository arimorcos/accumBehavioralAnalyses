%runSpeedPerc.m

%function to analyze the running speed of the mouse through a specific percentage of the MazeLengthAhead Vector 

%ASM 6/26/12

function [runData] = runSpeedPerc(data,dataCell,exper,startPerc,endPerc)
   
    %get times of trial start and end
    [times] = getTrialStartEndTimes(data);
    
    %get MazeLengthAhead
    mazeLength = str2double(exper.variables.MazeLengthAhead);
    startVal = startPerc*mazeLength;
    endVal = endPerc*mazeLength;
    
    travelTime = zeros(1,length(times.trialEndTimesIndex));
    
    for i=1:length(times.trialEndTimesIndex)
       indexValues = times.trialStartTimesIndex(i):times.trialEndTimesIndex(i);
       index(1) = indexValues(find(data(3,indexValues) >= startVal,1,'first'));
       index(2) = indexValues(find(data(3,indexValues)<=endVal,1,'last'));
       
       travelTime(i) = data(1,index(2)) - data(1,index(1));
    end
    
    runData.secs = dnum2secs(travelTime);
    runData.mean = mean(runData.secs);
    runData.median = median(runData.secs);
    runData.STD = std(runData.secs);
end