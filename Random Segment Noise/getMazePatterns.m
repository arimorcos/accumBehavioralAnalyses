function [mazePatterns,nSeg] = getMazePatterns(dataCell)
%getMazePatterns.m Extracts maze patterns from dataCell and returns a
%nTrials x nSeg array containing whether each segment is left or white
%
%INPUTS
%dataCell - cell array of trials
%
%OUTPUTS
%mazePatterns - nTrials x nSeg array containing whether each segment is
%   left or white
%nSeg - number of segments
%
%ASM 10/13

%determine if dataCell has white or left data
if isfield(dataCell{1}.maze,'numLeft')
    flagLeft = true;
else
    flagLeft = false;
end

%extract leftDotLoc or whiteDots
if flagLeft 
    segLocs = cellfun(@(x) x.maze.leftDotLoc,dataCell,'UniformOutput',false);
else
    segLocs = cellfun(@(x) x.maze.whiteDots,dataCell,'UniformOutput',false);
end

%get nSeg
% nSeg = max(cat(1,segLocs{:}));
nSeg = 6;

%get nTrials
nTrials = length(dataCell);

%initialize mazePatterns
mazePatterns = zeros(nTrials,nSeg);

%loop through segLoc
for i = 1:nTrials
    mazePatterns(i,segLocs{i}) = 1;
end