function figH = errorVsCorrectPatterns(dataCell)
%errorVsCorrectPatterns.m Plots error trials vs. correct trial patterns
%
%INPUTS
%dataCell - dataCell to analyze
%
%OUTPUTS
%figH - figure handle
%
%ASM 6/14

%split up into correct and error
corrTrials = getTrials(dataCell,'result.correct==1;maze.crutchTrial==0');
errTrials = getTrials(dataCell,'result.correct==0;maze.crutchTrial==0');

%create figure
figH = figure('Name',sprintf('Correct Vs. Error Trial Pattterns -- Mouse %d -- Date %s',...
    dataCell{1}.info.mouse,dataCell{1}.info.date));

%create correct plot
correctAx = subplot(1,2,1);
plotMazePatterns(corrTrials,figH,correctAx);
title('Correct Trials','FontSize',20);

%create error plot
errorAx = subplot(1,2,2);
plotMazePatterns(errTrials,figH,errorAx);
title('Error Trials','FontSize',20);