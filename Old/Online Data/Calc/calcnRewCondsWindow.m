%calcnRewCondsWindow.m

%function to calculate the number of rewards for each condition present in
%the data array over the last X trials

%ASM 6/13/12

function [nRewCondsWin] = calcnRewCondsWindow(data,leftMazes,timesWindow)
    
        nRewCondsWin = zeros(length(leftMazes),1);
        for i=1:length(leftMazes)
            nRewCondsWin(i) = sum(data(8,data(7,timesWindow.trialEndTimesIndex+1)==i)~=0);
        end
end