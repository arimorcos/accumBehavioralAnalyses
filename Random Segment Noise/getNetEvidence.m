function netEv = getNetEvidence(dataCell)
%getNetEvidence.m Extracts net evidence readings
%
%INPUTS
%dataCell - dataCell containing integration information
%
%OUTPUTS
%netEv - nTrials x nSeg array containing net evidence. Positive means
%   left/white
%
%ASM 7/14

%get mazePatterns
mazePatterns = getMazePatterns(dataCell);

%set 0 values to - 1
mazePatterns(mazePatterns == 0) = -1;

%take cumsum of mazePatterns
netEv = cumsum(mazePatterns,2);
