%calcPercLeftPaired

%function to calculate the percent left turns for the tower and no tower
%conditions

%ASM 6/14/12

function [percLeftTower percLeftNoTower] = calcPercLeftPaired(leftMazes,nTrialsConds,nRewConds)
    
    leftMazes = leftMazes';

    percLeftTower = 100*(sum(nRewConds(leftMazes == 1 & mod(nRewConds,2) == 1))...
        + sum(nTrialsConds(leftMazes == 0 & mod(nRewConds,2) == 1))...
            - sum(nRewConds(leftMazes == 0 & mod(nRewConds,2) == 1)))/sum(nTrialsConds(mod(nRewConds,2) == 1));
        
    percLeftNoTower = 100*(sum(nRewConds(leftMazes == 1 & mod(nRewConds,2) == 0))...
        + sum(nTrialsConds(leftMazes == 0 & mod(nRewConds,2) == 0))...
        - sum(nRewConds(leftMazes == 0 & mod(nRewConds,2) == 0)))/sum(nTrialsConds(mod(nRewConds,2) == 0));

end