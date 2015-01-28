function [meanVals,stdVals,mazeTypes] = analyzeCutTurnMultiMice(mice)
%analyzeCutTurn.m compares cut turn to non-cut turn

%get number of mice 
nMice = length(mice);

%initialize
mazeTypes = {'Maze1_40','Maze1_(?!40_)','Maze2','Maze3','Maze4'};
mazeDist = cell(2,length(mazeTypes));

for i = 1:nMice %for each mouse 
    
    dispProgress('Current Mouse: %s  Progress: %02d out of %02d\n',...
        i,mice{i},i,nMice);
    
    %run analyzePerf
    [perf.(mice{i}), cutAnal.(mice{i})] = analyzeCutTurnOverTime(mice{i});    
    
    %run through each maze type and cat
    for j = 1:length(mazeTypes)
        mazeDist{1,j} = [mazeDist{1,j} cutAnal.(mice{i}){1,j}];
        mazeDist{2,j} = [mazeDist{2,j} cutAnal.(mice{i}){2,j}];
    end
    
end

%get mean and std
meanVals = zeros(2,length(mazeTypes));
stdVals = zeros(2,length(mazeTypes));
for i = 1:length(mazeTypes)
    meanVals(1,i) = mean(mazeDist{1,i});
    meanVals(2,i) = mean(mazeDist{2,i});
    stdVals(1,i) = std(mazeDist{1,i});
    stdVals(2,i) = std(mazeDist{2,i});
end

%plot
mazeTypes = {'Maze1_40','Maze1','Maze2','Maze3','Maze4'};
plotCutTurn(meanVals,stdVals,mazeTypes);
end