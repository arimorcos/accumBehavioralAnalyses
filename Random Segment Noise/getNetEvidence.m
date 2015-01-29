function netEv = getNetEvidence(dataCell)
%getNetEvidence.m Extracts net evidence readings
%
%INPUTS
%dataCell - dataCell containing integration information || mazePatterns
%
%OUTPUTS
%netEv - nTrials x nSeg array containing net evidence. Positive means
%   left/white
%
%ASM 7/14

%get mazePatterns
if iscell(dataCell)
    mazePatterns = getMazePatterns(dataCell);
else
    mazePatterns = dataCell;
end

%set 0 values to - 1
mazePatterns(mazePatterns == 0) = -1;

%take cumsum of mazePatterns
netEv = cumsum(mazePatterns,2);
