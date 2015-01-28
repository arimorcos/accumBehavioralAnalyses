%calcPercWhitePaired

%function to calculate the percent white turns for the tower and no tower
%conditions

%ASM 6/14/12

function [percwhiteTower percwhiteNoTower] = calcPercWhitePaired(whiteMazes,nTrialsConds,nRewConds)

    whiteMazes = whiteMazes';

    percwhiteTower = 100*(sum(nRewConds(whiteMazes == 1 & mod(nRewConds,2) == 1))...
        + sum(nTrialsConds(whiteMazes == 0 & mod(nRewConds,2) == 1))...
            - sum(nRewConds(whiteMazes == 0 & mod(nRewConds,2) == 1)))/sum(nTrialsConds(mod(nRewConds,2) == 1));
        
    percwhiteNoTower = 100*(sum(nRewConds(whiteMazes == 1 & mod(nRewConds,2) == 0))...
        + sum(nTrialsConds(whiteMazes == 0 & mod(nRewConds,2) == 0))...
        - sum(nRewConds(whiteMazes == 0 & mod(nRewConds,2) == 0)))/sum(nTrialsConds(mod(nRewConds,2) == 0));

end