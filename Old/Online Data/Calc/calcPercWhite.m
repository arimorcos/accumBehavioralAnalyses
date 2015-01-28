%calcPercWhite.m

%function to calculate percent of turns to white

%ASM 6/13/12

function [percWhite] = calcPercWhite(whiteMazes,nTrialsConds,nRewConds)

    percWhite = 100*(sum(nRewConds(whiteMazes == 1)) + sum(nTrialsConds(whiteMazes == 0))...
            - sum(nRewConds(whiteMazes == 0)))/sum(nTrialsConds);

end