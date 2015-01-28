nSim = 1e4;
vr.numLeft = zeros(1,nSim);
vr.numSeg = 6;

vr.difficulty = 1; %1 - hard, 2 - medium, 3 - easy

%maze probabilities
       %segment 1 2 3 4 5 6
vr.mazePatterns = [1 1 1 1 1 1;... %6-0 a
                0 1 1 1 1 1;... %5-1 b
                1 1 1 1 1 0;... %5-1 c
                1 1 0 0 1 1;... %4-2 d
                1 0 1 1 0 1;... %4-2 f
                1 1 1 1 0 0;... %4-2 g
                1 1 1 0 0 0;... %3-3 h
                1 0 1 0 1 0];   %3-3 i

% vr.nDiff = [1 2 3 2];            
%specify probabilities
              % HARD           MEDIUM       EASY
vr.mazeProbs = [0.3/1         0.4/1       0.5/1;...  %a
                0.3/2         0.3/2       0.35/2;...  %b
                0.3/2         0.3/2       0.35/2;...  %c
                0.3/3         0.3/3       0.15/3;...  %d
                0.3/3         0.3/3       0.15/3;...  %f
%                 0.3/3         0.3/3       0.15/3;
                0.1/2         0/2         0/2;...     %g
                0.1/2         0/2         0/2   ];    %h

goesWrong = zeros(1,vr.numSeg);
for i = 1:nSim
    vr.cuePos = randi([0 1]);
    if vr.cuePos == 1
        vr.leftDotLoc = find(vr.mazePatterns(randsample(size(vr.mazeProbs,1),...
            1,true,vr.mazeProbs(:,vr.difficulty)),:)==1)';
        vr.numLeft(i) = length(vr.leftDotLoc);
        goesWrong(setdiff(1:vr.numSeg,vr.leftDotLoc)) = ...
            goesWrong(setdiff(1:vr.numSeg,vr.leftDotLoc)) + 1;
    else
        vr.leftDotLoc = setdiff(1:vr.numSeg,find(vr.mazePatterns(randsample(...
            size(vr.mazeProbs,1),1,true,vr.mazeProbs(:,vr.difficulty)),:)==1))';
        vr.numLeft(i) = length(vr.leftDotLoc);
        goesWrong(vr.leftDotLoc) = goesWrong(vr.leftDotLoc) + 1;
    end
    
end

figure;
subplot(2,1,1);
hist(vr.numLeft,vr.numSeg+1)
xlabel('Number of left segments')
ylabel('Count');
subplot(2,1,2)
bar(1:vr.numSeg,goesWrong);
xlabel('Segment #')
ylabel('Count toward wrong side');