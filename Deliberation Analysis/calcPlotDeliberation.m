function figH = calcPlotDeliberation(mouse,dataCell,thresh)
%calcPlotDeliberaiton.m Function which calculated info from deliberation
%trials and plots them
%
%INPUTS
%mouse - mouse name (string)
%dataCell - cell array of trial structures
%thresh - threshold for other arm
%
%OUTPUTS
%figH - figure handle
%
%ASM 11/13

if nargin < 3 || isempty(thresh)
    thresh = 0.25;
end

%calculate
[delibFreq,delibPerf,nonDelibPerf,subsets] = ...
    calcDeliberationTrials(dataCell,thresh);

%plot
figH = plotDeliberationData(delibFreq,delibPerf,nonDelibPerf,...
    subsets,mouse,length(dataCell));