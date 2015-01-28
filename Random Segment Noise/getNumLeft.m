function numLeft = getNumLeft(dataCell)
%getNumLeft.m Extracts num left readings
%
%INPUTS
%dataCell - dataCell containing integration information
%
%OUTPUTS
%numLeft - nTrials x nSeg array containing net evidence. Positive means
%   left/white
%
%ASM 11/14

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%take cumsum
numLeft = cumsum(mazePatterns,2);
