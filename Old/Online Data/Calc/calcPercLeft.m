%calcPercLeft.m

%function to calculate percent of turns to the left

%ASM 6/13/12

function [percLeft] = calcPercLeft(leftMazes,nTrialsConds,nRewConds)

    percLeft = 100*(sum(nRewConds(leftMazes == 1)) + sum(nTrialsConds(leftMazes == 0))...
            - sum(nRewConds(leftMazes == 0)))/sum(nTrialsConds);

end