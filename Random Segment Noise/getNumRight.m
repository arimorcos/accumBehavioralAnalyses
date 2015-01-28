function numRight = getNumRight(dataCell)
%getNumRight.m Extracts num right readings
%
%INPUTS
%dataCell - dataCell containing integration information
%
%OUTPUTS
%numRight - nTrials x nSeg array containing net evidence. Positive means
%   left/white
%
%ASM 11/14

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%flip
mazePatterns = ~mazePatterns;

%take cumsum
numRight = cumsum(mazePatterns,2);
