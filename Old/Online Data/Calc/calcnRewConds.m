%calcnRewConds.m

%function to calculate the number of rewards for each condition present in
%the data array

%ASM 6/13/12

function [nRewConds] = calcnRewConds(data,leftMazes)
    
    nRewConds = zeros(length(leftMazes),1);
    for i=1:length(leftMazes)
        nRewConds(i) = sum(data(8,data(7,:)==i)~=0);
    end
    
end