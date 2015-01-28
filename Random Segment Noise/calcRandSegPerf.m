function [simPerf,mousePerf] = calcRandSegPerf(dataCell,nSim,numSegsToLook,...
    groupConds,allowCorrect,singSeg)
%calcRandSegPerf.m Analyzes mouse's performance on intermediate conditions
%(5-1,4-2, etc.) assuming same amount of noise as in 6-0 conditions. For
%example, if mouse performs 90% on 6-0 (instead of expected 100% if only
%looking at random segment), then noise accounting for 10% drop should be
%present in all segments. Simulates trials of same pattern as those in
%dataCell to calculate expected performance taking this into account.
%
%INPUTS
%dataCell - dataCell of trials
%nSim - number of simulations to perform. If empty, 1000.
%numSegsToLook - number of segments to analyze. If empty, 1.
%groupConds - group equal and opposite conditions (6-0 and 0-6)
%allowCorrect - allow changes from incorrect to correct
%singSeg - single segment to look at. If empty, randomly determined
%
%OUTPUTS
%simPerf - nSim x nConds array containing percent left/white for each
%   condition
%mousePerf - 1 x nConds array containing percent left/white mouse turned
%
%ASM 10/13

%check if singSeg given
if nargin < 6
    singSeg = [];
end

%check if allow incorrect
if nargin < 5 || isempty(allowCorrect)
    allowCorrect = true;
end

%check if group conditions
if nargin < 4 || isempty(groupConds)
    groupConds = false;
end

%check if numSegsToLook given
if nargin < 3 || isempty(numSegsToLook)
    numSegsToLook = 1;
end

%check if nSim provided
if nargin < 2 || isempty(nSim)
    nSim = 1000;
end

%get maze patterns from dataCell
[mazePatterns, nSeg] = getMazePatterns(dataCell);

%get nTrials
nTrials = length(dataCell);

%determine if dataCell has white or left data
if isfield(dataCell{1}.maze,'numLeft')
    flagLeft = true;
else
    flagLeft = false;
end

%generate condInds
condInds = zeros(nTrials,nSeg+1);
for i = 1:nSeg+1
    if flagLeft
        condInds(:,i) = findTrials(dataCell,sprintf('maze.numLeft == %d',i-1));
    else
        condInds(:,i) = findTrials(dataCell,sprintf('maze.numWhite == %d',i-1));
    end
end

%get zero and oneTrials (endpoints)
if flagLeft 
    oneTrials = getTrials(dataCell,sprintf('maze.numLeft == %d',nSeg));
    zeroTrials = getTrials(dataCell,'maze.numLeft == 0');
else
    oneTrials = getTrials(dataCell,sprintf('maze.numWhite == %d',nSeg));
    zeroTrials = getTrials(dataCell,'maze.numWhite == 0');
end

%calculate percent incorrect in each
oneSwitchFrac = sum(findTrials(oneTrials,'result.correct==0'))/length(oneTrials);
zeroSwitchFrac = sum(findTrials(zeroTrials,'result.correct==0'))/length(zeroTrials);
% oneSwitchFrac = 0;
% zeroSwitchFrac = 0;

%initialize perf
if groupConds
    simPerf = zeros(nSim,ceil(0.5*(nSeg+1)));
else
    simPerf = zeros(nSim,nSeg+1);
end

%perform simulations
for i = 1:nSim
    simPerf(i,:) = simRandSegNoise(mazePatterns,oneSwitchFrac,zeroSwitchFrac,...
        condInds,numSegsToLook,nSeg,groupConds,allowCorrect,singSeg);
end

%calculate mouse performance
if groupConds
    mousePerf = zeros(1,ceil(0.5*(nSeg+1)));
    for i = 1:ceil(0.5*(nSeg+1))
        if flagLeft
            if i == ceil(0.5*(nSeg+1))
                trialSub = getTrials(dataCell,sprintf('maze.numLeft == %d',i-1));
            else
                trialSub = getTrials(dataCell,sprintf('maze.numLeft == %d,%d',i-1,nSeg+1-i));
            end
            mousePerf(i) = 100*sum(findTrials(trialSub,'result.correct == 1'))/length(trialSub);
        else
            if i == ceil(0.5*(nSeg+1))
                trialSub = getTrials(dataCell,sprintf('maze.numWhite == %d',i-1));
            else
                trialSub = getTrials(dataCell,sprintf('maze.numWhite == %d,%d',i-1,nSeg+1-i));
            end
            mousePerf(i) = 100*sum(findTrials(trialSub,'result.correct == 1'))/length(trialSub);
        end
    end
else
    mousePerf = zeros(1,nSeg+1);
    for i = 1:nSeg+1
        %get trial subset
        if flagLeft
            trialSub = getTrials(dataCell,sprintf('maze.numLeft == %d',i-1));
            %calculate percent left/white
            mousePerf(i) = 100*sum(findTrials(trialSub,'result.leftTurn == 1'))/length(trialSub);
        else
            trialSub = getTrials(dataCell,sprintf('maze.numWhite == %d',i-1));
            mousePerf(i) = 100*sum(findTrials(trialSub,'result.whiteTurn == 1'))/length(trialSub);
        end
    end
end




