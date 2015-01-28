%calcScaleFacQuarts

%function to calculate performance at four scale factor quartiles and at 1

%scaleFacQuarts(:,1) = performance at 1, (:,2) = performance .75 - .99, (:,3) =
%performance .5 - .74, (:,4) = performance .25 - .49, (:,5) = performance
%0 - .24. (1,:) = numTrials, (2,:) = numRewards, (3,:) = percCorr

function [scaleFacQuarts] = calcScaleFacQuarts(data,times)
    
    scaleFacQuarts = zeros(3,5);
    
    %get numTrials for each
    scaleFacQuarts(1,1) = sum(data(11,times.trialEndTimesIndex) == 1);
    scaleFacQuarts(1,2) = sum(data(11,times.trialEndTimesIndex) < 1 & data(11,times.trialEndTimesIndex) >= 0.75);
    scaleFacQuarts(1,3) = sum(data(11,times.trialEndTimesIndex) < 0.75 & data(11,times.trialEndTimesIndex) >= 0.5);
    scaleFacQuarts(1,4) = sum(data(11,times.trialEndTimesIndex) < 0.5 & data(11,times.trialEndTimesIndex) >= 0.25);
    scaleFacQuarts(1,5) = sum(data(11,times.trialEndTimesIndex) < 0.25 & data(11,times.trialEndTimesIndex) >= 0);
    
    %get nRew for each
    scaleTrials1 = times.trialEndTimesIndex(data(11,times.trialEndTimesIndex) == 1);
    scaleTrials2 = times.trialEndTimesIndex(data(11,times.trialEndTimesIndex) < 1 & data(11,times.trialEndTimesIndex) >= 0.75);
    scaleTrials3 = times.trialEndTimesIndex(data(11,times.trialEndTimesIndex) < 0.75 & data(11,times.trialEndTimesIndex) >= 0.5);
    scaleTrials4 = times.trialEndTimesIndex(data(11,times.trialEndTimesIndex) < 0.5 & data(11,times.trialEndTimesIndex) >= 0.25);
    scaleTrials5 = times.trialEndTimesIndex(data(11,times.trialEndTimesIndex) < 0.25 & data(11,times.trialEndTimesIndex) >= 0);
    
    scaleFacQuarts(2,1) = sum(data(8,scaleTrials1+1) ~= 0);
    scaleFacQuarts(2,2) = sum(data(8,scaleTrials2+1) ~= 0);
    scaleFacQuarts(2,3) = sum(data(8,scaleTrials3+1) ~= 0);
    scaleFacQuarts(2,4) = sum(data(8,scaleTrials4+1) ~= 0);
    scaleFacQuarts(2,5) = sum(data(8,scaleTrials5+1) ~= 0);
    
    %calclulate percRew
    scaleFacQuarts(3,:) = 100*scaleFacQuarts(2,:)./scaleFacQuarts(1,:);
    
    
    
    
end