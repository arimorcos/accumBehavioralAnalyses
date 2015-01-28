%get explanatory variables (segments)
numTrials = length(dataCell);
% numSeg = max(getCellVals(dataCell,'maze.numLeft'));
mazePatterns = getMazePatterns(dataCell);

%get response variables (turns toward white)
leftTurns = getCellVals(dataCell,'result.leftTurn')';

%perform regression
[beta,betaConf,r,rConf] = regress(leftTurns,mazePatterns);

%plot data
figure;
% behavGUI.behavPlot = subplot('Position',[0.05 0.15 0.9 0.8]);
behavGUI.behavScatter = errorbar(1:length(beta),beta,beta-betaConf(:,1),abs(beta-betaConf(:,2)),...
    'bo','MarkerFaceColor','b','MarkerSize',10,'LineStyle','none');
xlim([0 length(beta)+1]);
ylabel('Beta');
xlabel('Segment Number');
set(gca,'XTick',1:length(beta));
title('Behavioral Weights');
axis square;