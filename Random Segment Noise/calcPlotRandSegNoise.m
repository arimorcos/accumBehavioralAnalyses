function [simPerf,mousePerf] = calcPlotRandSegNoise(dataCell,nSim,...
    numSegsToLook,groupConds,allowCorrect,singSeg)
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

%calculate
[simPerf,mousePerf] = calcRandSegPerf(dataCell,nSim,numSegsToLook,...
    groupConds,allowCorrect,singSeg);

%plot
plotRandSegNoise(mousePerf,simPerf,groupConds);