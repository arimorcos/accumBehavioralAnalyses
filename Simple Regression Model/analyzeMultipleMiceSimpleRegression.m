mice = {'AM136','AM142','AM144','AM150'};




for mouse = 1:length(mice)
    
    %generate file name 
    fName = sprintf('%s_manySessionBehavior_onlyDataCell',mice{mouse});
    
    %load 
    load(fName,'dataCell');
    
    %get medTrials
    medTrials = getTrials(dataCell,'maze.numLeft == 1,2,3,4,5');
    hardTrials = getTrials(dataCell,'maze.numLeft == 2,3,4');
    
    %run on each 
    [regressAcc.(mice{mouse}).medTrials.quarterTrain.accuracy,...
        regressAcc.(mice{mouse}).medTrials.quarterTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(medTrials,0.25);
    
    [regressAcc.(mice{mouse}).hardTrials.quarterTrain.accuracy,...
        regressAcc.(mice{mouse}).hardTrials.quarterTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(hardTrials,0.25);
    
    [regressAcc.(mice{mouse}).allTrials.quarterTrain.accuracy,...
        regressAcc.(mice{mouse}).allTrials.quarterTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(dataCell,0.25);
    
    [regressAcc.(mice{mouse}).medTrials.halfTrain.accuracy,...
        regressAcc.(mice{mouse}).medTrials.halfTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(medTrials,0.5);
    
    [regressAcc.(mice{mouse}).hardTrials.halfTrain.accuracy,...
        regressAcc.(mice{mouse}).hardTrials.halfTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(hardTrials,0.5);
    
    [regressAcc.(mice{mouse}).allTrials.halfTrain.accuracy,...
        regressAcc.(mice{mouse}).allTrials.halfTrain.naiveAccuracy] =...
        getDecisionRegressionAccuracy(dataCell,0.5);
    
    clear dataCell
end

save('processedSimpleRegressionAcc','regressAcc');