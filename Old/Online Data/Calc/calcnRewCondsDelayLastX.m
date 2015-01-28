%calcnRewCondsDelayLastX.m

%function to calculate the number of rewards for each condition present in
%the data array for each delay

%ASM 6/14/12

function [nRewConds] = calcnRewCondsDelayLastX(data,leftMazes,times,delayValue)
    
    nRewConds = zeros(length(leftMazes),1);
    for i=1:length(leftMazes)
        condsDelay = times.trialEndTimesIndex(data(7,times.trialEndTimesIndex)==i & data(10,times.trialEndTimesIndex) == delayValue);
        nRewConds(i) = sum(data(8,condsDelay+1)~=0);
    end
    
end