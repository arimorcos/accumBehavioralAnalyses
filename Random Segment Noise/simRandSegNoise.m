function [perf] = simRandSegNoise(mazePattern,oneSwitchFrac,zeroSwitchFrac,...
    condInds,numSegsToLook,nSeg,groupConds,allowCorrect,singSeg)
%simRandSegNoise.m Simulates looking at 1 - 6 segments and calculates
%performance based on noise present in left and right trials broken down by
%conditions
%
%INPUTS
%mazePattern - nTrials x nSeg array of maze patterns
%oneSwitchFrac - fraction of trials where a 1 in maze pattern is determined
%   to switch
%zeroSwitchFrac - fraction of trials where a 0 in maze pattern is determined
%   to switch
%condInds - nTrials x nSeg+1 array of indices for each condition (0 left, 1
%   left, etc.)
%numSegsToLook - number of segments over which to determine turn
%nSeg - number of segments
%groupConds - group equal and opposite conditions (6-0 and 0-6)
%allowCorrect - allow changes from incorrect to correct
%singSeg - array of specific segments to look at
%
%OUTPUTS
%perf = 1 x nSeg + 1 array containing percentOneTurns in each condition
%
%ASM 10/13

%ignore singSeg if emtpy
if nargin < 7 || isempty(singSeg)
    randSegFlag = true;
else
    randSegFlag = false;
end

%get nConds
nConds = nSeg + 1;

%initialize perf
if groupConds
    perfDist = cell(1,nConds);
    perf = zeros(1,ceil(0.5*(nSeg+1)));
else
    perf = zeros(1,nConds);
end

%cycle through each condition
for i = 1:nConds
    
    %skip if empty
    if sum(condInds(:,i)) == 0
        if groupConds
            perfDis{i} = NaN;
        else
            perf(i) = NaN;
        end
        continue;
    end
    
    %get maze pattern subset
    mazePattSub = mazePattern(logical(condInds(:,i)),:);
    
    %get nTrials in cond
    nCondTrials = size(mazePattSub,1);
    
    %determine expected turn
    expectedTurn = nan(nCondTrials,1);
    for j = 1:nCondTrials
        expectedTurn(j) = mean(mazePattSub(j,randperm(nSeg,numSegsToLook)));
    end
    %     expectedTurn = mean(mazePattSub(:,segsToLook),2);
    
    %round expected turn if mixed
    expectedTurn(expectedTurn > 0.5) = 1;
    expectedTurn(expectedTurn < 0.5) = 0;
    expectedTurn(expectedTurn == 0.5) = randi([0 1],sum(expectedTurn == 0.5),1); %randomly determine if 0.5 (e.g. 1-1)
    
    %flip expected turn at expected rates
    if allowCorrect || i == ceil(nConds/2)
        expectedTurn(expectedTurn == 1) = randsample([0 1],sum(expectedTurn == 1),...
            true,[oneSwitchFrac,1-oneSwitchFrac]);
        expectedTurn(expectedTurn == 0) = randsample([0 1],sum(expectedTurn == 0),...
            true,[1 - zeroSwitchFrac,zeroSwitchFrac]);
    else
        if i < ceil(nConds/2) %if zero condition
            expectedTurn(expectedTurn == 0) = randsample([0 1],sum(expectedTurn == 0),...
                true,[1 - zeroSwitchFrac,zeroSwitchFrac]);
        elseif i > ceil(nConds/2) %if one condition
            expectedTurn(expectedTurn == 1) = randsample([0 1],sum(expectedTurn == 1),...
                true,[oneSwitchFrac,1-oneSwitchFrac]);
        end
    end
    
    %calculate performance
    if groupConds && i < ceil(0.5*(nSeg+1))
        perfDist{i} = 1-expectedTurn;
    elseif groupConds && i >= ceil(0.5*(nSeg+1))
        perfDist{i} = expectedTurn;
    else
        perf(i) = 100*sum(expectedTurn)/length(expectedTurn);
    end
end

%group
if groupConds
    midPoint = ceil(0.5*(nSeg+1));
    for i = 1:midPoint
        if i == midPoint
            dist = perfDist{i};
        else
            dist = cat(1,perfDist{i},perfDist{2*midPoint-i});                
        end
        perf(i) = 100*sum(dist)/length(dist);
    end
end






