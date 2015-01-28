%turnSpeed.m

%function to analyze the running speed of the mouse through the end of the
%maze

%ASM 6/26/12

function [turnData] = turnSpeed(data,exper,turnStartPerc)
   
    %get times of trial start and end
    [times] = getTrialStartEndTimes(data);
    
    %get MazeLengthAhead
    mazeLength = str2double(exper.variables.MazeLengthAhead);
    startVal = turnStartPerc*mazeLength;
    
    turnTime = zeros(2,length(times.trialEndTimesIndex));
    
    for i=1:length(times.trialEndTimesIndex)
       indexValues = times.trialStartTimesIndex(i):times.trialEndTimesIndex(i);
       index(1) = indexValues(find(data(3,indexValues) >= startVal,1,'first'));
       index(2) = times.trialEndTimesIndex(i);
       
       turnTime(1,i) = data(1,index(2)) - data(1,index(1));
       if data(2,times.trialEndTimesIndex(i)) > 0
           turnTime(2,i) = 1; %is right
       else
           turnTime(2,i) = 0; %is left
       end
    end
    
    [turnData.secs] = dnum2secs(turnTime(1,:));
    [turnData.secsLeft] = dnum2secs(turnTime(1,turnTime(2,:) == 0));
    [turnData.secsRight] = dnum2secs(turnTime(1,turnTime(2,:) == 1));
    
    turnData.mean = mean(turnData.secs);
    turnData.median = median(turnData.secs);
    turnData.STD = std(turnData.secs);
    
    turnData.meanLeft = mean(turnData.secsLeft);
    turnData.medianLeft = median(turnData.secsLeft);
    turnData.STDLeft = std(turnData.secsLeft);
    
    turnData.meanRight = mean(turnData.secsRight);
    turnData.medianRight = median(turnData.secsRight);
    turnData.STDRight = std(turnData.secsRight);
end