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
    nVar = 8;
end

%open file
fid = fopen(path);

%read in data
string = repmat('%f, ', 1, nVar);
string = string(1:end-2);
C = textscan(fid,string,'Delimiter','\n');

%check if only one param 
if length(C{1}) == 1 
    
    %rewind 
    frewind(fid);
    
    %scan again
    C = textscan(fid,'%f,  ');
    params = reshape(C{1},nVar,[])';
else
    %convert to matrix
    params = cat(2, C{:});
end

%close file
fclose(fid);