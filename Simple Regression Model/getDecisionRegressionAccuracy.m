function [accuracy, naiveAccuracy] = getDecisionRegressionAccuracy(dataCell,fracTrain)
%getDecisionRegressionAccuracy.m Calculates predicted decision accuracy
%based on regression 
%
%INPUTS
%dataCell - dataCell containing integration data 
%fracTrain - fraction of trials to train on
%
%OUTPUTS 
%accuracy - percent correct 
%naiveAccuracy - percent correct given equal weighting 
%
%ASM 4/15

%check inputs
if ~iscell(fracTrain)
    assert(fracTrain > 0 & fracTrain < 1, 'fracTrain must be a fraction. Current value, %d, is invalid',fracTrain);
    
    %remove crutch trials 
    dataCell = getTrials(dataCell,'maze.crutchTrial==0');
    
    %get nTrain
    nTrain = round(fracTrain*length(dataCell));
    
    trainSet = dataCell(1:nTrain);
    testCell = dataCell(nTrain+1:end);
else
    testCell = fracTrain;
    testCell = getTrials(testCell,'maze.crutchTrial==0');
    trainSet = dataCell;
end

%train 
segWeights = getSegWeights(trainSet);

%%%%% test 

%get testCell
nTest = length(testCell);

%get mazePatterns 
mazePatterns = getMazePatterns(testCell);

%get guesses and confidence 
guess = predictDecisionRegression(mazePatterns,segWeights);

%get actual turns 
turns = getCellVals(testCell,'result.leftTurn')';

%get accuracy 
accuracy = sum(guess==turns)/nTest;

%calculate naive accuracy 
nSeg = size(mazePatterns,2);
naiveGuess = sum(mazePatterns,2);
naiveGuess(naiveGuess == nSeg/2) = randsample([2 4],sum(naiveGuess == nSeg/2),1);
naiveGuess = naiveGuess > nSeg/2;
naiveAccuracy = sum(naiveGuess == turns)/nTest;