function [segWeights, confInt] = getSegWeights(dataCell)
%getSegWeights.m Performs a multivariate linear regression and gets segment
%weights 
%
%INPUTS
%dataCell 
%
%OUTPUTS
%segWeights - nSeg x 1 array of segment weights
%confInt - nSeg x 2 array of confidence intervals
%
%ASM 4/15

%get mazePatterns 
mazePatterns = getMazePatterns(dataCell);

%get turn 
turn = getCellVals(dataCell,'result.leftTurn')';

%perform regression
[segWeights, confInt] = regress(turn,mazePatterns);