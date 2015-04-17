function [guess, conf] = predictDecisionRegression(mazePatterns, segWeights)
%predictDecisionRegression.m Predicts the decision using regression 
%
%INPUTS
%mazePattern - nSeg x nTrials array of segments 
%segWeights - nSeg x 1 array of semgent weights 
%
%OUPTUTS
%guess - nTrials x 1 array of guesses
%confidence - nTrials x 1 array of confidence ranging from 0 to 1 
%
%ASM 4/15

%normalize segWeights 
segWeights = segWeights/sum(segWeights);

%take weighted sum 
weightedSum = mazePatterns*segWeights;

%get guess
guess = nan(size(weightedSum));
guess(weightedSum ~= 0.5) = weightedSum(weightedSum ~= 0.5) > 0.5;
guess(weightedSum == 0.5) = randi([0 1],sum(weightedSum == 0.5),1);

%get confidence 
conf = 2*abs(weightedSum - 0.5);