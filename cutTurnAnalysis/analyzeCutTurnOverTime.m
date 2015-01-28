function [perf,cutAnal] = analyzeCutTurnOverTime(anName)
%analyzeCutTurnOverTime.m Loops through each dataCell, finds if cut turn or
%not and record change
%
%ASM 10/13

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
perf = getPerfOverTimeCutTurn(anDir);

%for each type, filter out
mazeTypes = {'Maze1_40','Maze1_(?!40_)','Maze2','Maze3','Maze4'};
cutAnal = cell(2,length(mazeTypes));
for i = 1:length(mazeTypes)
    
    %find which indices match
    typeInds = cell2mat(cellfun(@(x) ~isempty(x),regexp(perf.mazeNames,mazeTypes{i}),'UniformOutput',false));
    
    %look for cut turns
    cutInds = cell2mat(cellfun(@(x) ~isempty(x),regexp(perf.mazeNames,'_cutTurn'),'UniformOutput',false));
    
    %combine ind
    nonCutTypeInd = typeInds & ~cutInds;
    cutTypeInd = typeInds & cutInds;
    
    %get mean of tpm and std
    cutAnal{1,i} = perf.tpm(nonCutTypeInd);
    cutAnal{2,i} = perf.tpm(cutTypeInd);
end
    
   
