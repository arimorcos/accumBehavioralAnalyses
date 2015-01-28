%calcnRewCondsLastX.m

%function to calculate the number of rewards for each condition present in
%the data array over the last X trials

%ASM 6/13/12

function [nRewCondsLastX] = calcnRewCondsLastX(data,leftMazes,timesLastX)

        nRewCondsLastX = zeros(length(leftMazes),1);
        for i=1:length(leftMazes)
            condTrials = timesLastX.trialEndTimesIndex(data(7,timesLastX.trialEndTimesIndex)==i);
            nRewCondsLastX(i) = sum(data(8,condTrials+1)~=0);
        end
end