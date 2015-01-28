function [delibFreq,delibPerf,nonDelibPerf,subsets] = ...
    calcDeliberationTrials(dataCell,thresh)
%calcDeliberationTrials.m Function to determine percent correct on
%deliberation trials and frequency of deliberation trials
%
%INPUTS
%dataCell - cell array of structures
%thresh - threshold for considering a deliberation trial
%
%OUTPUTS
%delibFreq - frequency of deliberations in each subset
%delibPerf - performance on deliberation tirals in each subset
%nonDelibPerf - performance on non-deliberation trials in each subset
%subsets - names of subsets
%
%ASM 11/13

%name subsets
subsets = {'all','crutchSub','nonCrutchSub','sub60','sub51','sub42','sub3'};
nSub = length(subsets);

%break up into subsets
subs.all = dataCell;
subs.crutchSub = getTrials(dataCell,'maze.crutchTrial == 1');
subs.nonCrutchSub = getTrials(dataCell,'maze.crutchTrial == 0');
subs.sub60 = getTrials(subs.nonCrutchSub,'maze.numLeft == 0,6');
subs.sub51 = getTrials(subs.nonCrutchSub,'maze.numLeft == 1,5');
subs.sub42 = getTrials(subs.nonCrutchSub,'maze.numLeft == 2,4');
subs.sub3 = getTrials(subs.nonCrutchSub,'maze.numLeft == 3');

%initialize info
delibFreq = zeros(1,nSub);
delibPerf = zeros(1,nSub);
nonDelibPerf = zeros(1,nSub);

%cycle through each subset
for i = 1:nSub
    
    %find deliberation trials
    delibTrials = findDeliberationTrials(subs.(subsets{i}),thresh);
    
    %calculate frequency
    delibFreq(i) = sum(delibTrials)/length(delibTrials);
    
    %calculate performance on deliberation vs. non deliberation
    delibPerf(i) = 100*sum(findTrials(subs.(subsets{i})(delibTrials),'result.correct==1'))/...
        sum(delibTrials);
    nonDelibPerf(i) = 100*sum(findTrials(subs.(subsets{i})(~delibTrials),'result.correct==1'))/...
        sum(~delibTrials);
    
end
