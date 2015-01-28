%calcnTrialsConds.m

%function to calculate the number of trials for each condition present in
%the data array

%ASM 6/13/12

function [nTrialsConds] = calcnTrialsConds(data,times,leftMazes)
    
    nTrialsConds = zeros(length(leftMazes),1);
    for i=1:length(leftMazes)
        nTrialsConds(i) = sum(data(7,times.trialEndTimesIndex) == i);
    end
    
end