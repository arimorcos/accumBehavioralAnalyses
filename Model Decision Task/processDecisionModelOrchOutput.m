function params = processDecisionModelOrchOutput(path)
%processDecisionModelOrchOutput.m Processes output of decision model 
%
%INPUTS
%path - path to decisionTaskFit txt file
%
%OUTPUTS
%params - nRuns x nParams matrix of parameters
%
%ASM 3/15

%open file
fid = fopen(path);

%read in data
C = textscan(fid,'%f, %f, %f, %f, %f, %f, %f, %f, %f','Delimiter','\n');

%convert to matrix
params = cat(2, C{:});

%close file
fclose(fid);