function [perf, figHandle] = analyzePerfOverTime(anName,heat,startDate,endDate,silent)
%analyzePerfOverTime.m function to analyze performance of an animal over
%time and plot

if nargin < 5; silent = false; end
if nargin < 4 || isempty(startDate|endDate)
    allDates = true; 
    startDate = '';
    endDate = '';
else
    allDates = false; 
end
if nargin < 2; heat = true; end


%specify root directory
mouseDir = {'D:\Data\Ari\Current Mice','D:\Data\Ari\Archived Mice'};

mouseInd = 0;
for i=1:length(mouseDir) %check if folder exists
    if exist(fullfile(mouseDir{i},anName)) ~= 0
        mouseInd = i;
    end
end

if mouseInd == 0 %if folder does not exist return error
    error('No animal of that name');
end

%generate full directory
anDir = fullfile(mouseDir{mouseInd},anName);

%perform calculation
perf = getPerfOverTime(anDir,allDates,startDate,endDate);

%plot
plots.tpm = true;
plots.perf = false;

if heat
    figHandle(1) = heatMapPerfOverTime(perf,anName,silent);
    if plots.tpm || plots.perf
        figHandle(2) = scatterPerfOverTime(perf,anName,plots,silent);
    end
else
    figHandle = scatterPerfOverTime(perf,anName,plots,silent);
end

end