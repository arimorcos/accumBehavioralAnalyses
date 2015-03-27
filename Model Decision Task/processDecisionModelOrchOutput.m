function params = processDecisionModelOrchOutput(path, nVar)
%processDecisionModelOrchOutput.m Processes output of decision model 
%
%INPUTS
%path - path to decisionTaskFit txt file
%
%OUTPUTS
%params - nRuns x nParams matrix of parameters
%
%ASM 3/15

if nargin < 2 || isempty(nVar)
    nVar = 9;
end

%open file
fid = fopen(path);

%read in data
string = repmat('%f, ', 1, nVar);
string = string(1:end-2);
C = textscan(fid,string,'Delimiter','\n');

%convert to matrix
params = cat(2, C{:});

%close file
fclose(fid);