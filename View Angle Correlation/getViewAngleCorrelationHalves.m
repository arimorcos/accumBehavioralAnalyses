function [topHalf, bottomHalf] = getViewAngleCorrelationHalves(dataCell)
%getViewAngleCorrelationHalves.m Gets the top and bottom half of view angle
%correlations 
%
%INPUTS
%dataCell
%
%OUPUTS
%topHalf - trialIndices for top half
%bottomHalf - trialIndices for bottom half
%
%ASM 4/15

%get view angle correlations 
viewCorr = getViewAngleCorrelationToMean(dataCell);

%get median value 
medViewCorr = median(viewCorr);

%get trials 
topHalf = find(viewCorr >= medViewCorr);
bottomHalf = find(viewCorr < medViewCorr);