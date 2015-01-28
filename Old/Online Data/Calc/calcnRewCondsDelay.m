%calcnRewCondsDelay.m

%function to calculate the number of rewards for each condition present in
%the data array for each delay

%ASM 6/14/12

function [nRewConds] = calcnRewCondsDelay(data,leftMazes,delayValue)
    
    nRewConds = zeros(length(leftMazes),1);
    for i=1:length(leftMazes)
        nRewConds(i) = sum(data(8,data(7,:)==i & data(10,:) == delayValue)~=0);
    end
    
end