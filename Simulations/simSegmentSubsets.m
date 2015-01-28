function simSegmentSubsets()
%simSegmentSubsets.m Simulates prediction of correct answer for a given set
%of maze patterns and probabilities
%
%ASM 11/13

%%%%%%%%%%%%%%PARAMETERS%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%OPTION 1 - underweights 3/4
% %specify patterns to test
%        %segment 1 2 3 4 5 6
% mazePatterns = [1 1 1 1 1 1;... %6-0 a
%                 0 1 1 1 1 1;... %5-1 b
%                 1 1 0 1 1 1;... %5-1 c
%                 1 0 1 0 1 1;... %4-2 d
%                 1 1 1 1 0 0;... %4-2 e
%                 1 1 0 0 1 1;... %4-2 f
%                 1 1 1 0 0 0;... %3-3 g
%                 1 0 1 0 1 0];   %3-3 h
%             
% %specify probabilities
% mazeProbs = [0.250;...  %a
%              0.125;...  %b
%              0.125;...  %c
%              0.25/3;... %d
%              0.25/3;... %e
%              0.25/3;... %f
%              0.125;...  %g
%              0.125];    %h
       

% %OPTION 2 - CLOSER, BUT SPLITS UP 4-2 TOO MUCH
% %specify patterns to test
%        %segment 1 2 3 4 5 6
% mazePatterns = [1 1 1 1 1 1;... %6-0 a
%                 0 1 1 1 1 1;... %5-1 b
%                 1 1 0 1 1 1;... %5-1 c
%                 1 0 1 0 1 1;... %4-2 d
%                 1 1 1 1 0 0;... %4-2 e
%                 1 1 1 0 0 1;... %4-2 f
%                 1 0 0 1 1 1;... %4-2 g
%                 1 1 1 0 0 0;... %3-3 h
%                 1 0 1 0 1 0];   %3-3 i
%             
% %specify probabilities
% mazeProbs = [0.25/1;...  %a
%              0.25/2;...  %b
%              0.25/2;...  %c
%              0.25/4;...  %d
%              0.25/4;...  %e
%              0.25/4;...  %f
%              0.25/4;...  %g
%              0.25/2;...  %h
%              0.25/2];    %i
         
% %OPTION 3 - CLOSER, BUT HARMS 4/5 TOO MUCH
% %specify patterns to test
%        %segment 1 2 3 4 5 6
% mazePatterns = [1 1 1 1 1 1;... %6-0 a
%                 0 1 1 1 1 1;... %5-1 b
%                 1 1 1 1 0 1;... %5-1 c
%                 1 0 1 0 1 1;... %4-2 d
%                 1 1 1 1 0 0;... %4-2 e
%                 1 1 0 0 1 1;... %4-2 f
%                 1 1 1 0 0 0;... %3-3 g
%                 1 0 1 0 1 0];   %3-3 h
%             
% %specify probabilities
% mazeProbs = [0.25/1;...  %a
%              0.25/2;...  %b
%              0.25/2;...  %c
%              0.25/3;...  %d
%              0.25/3;...  %e
%              0.25/3;...  %f
%              0.25/2;...  %g
%              0.25/2];    %h
         
%OPTION 4 - MAYBE THE BEST, DOESN'T HAVE A MIDDLE 5-1 (16 CONDITIONS)
%specify patterns to test
       %segment 1 2 3 4 5 6
mazePatterns = [1 1 1 1 1 1;... %6-0 a
                0 1 1 1 1 1;... %5-1 b
                1 1 1 1 1 0;... %5-1 c
                1 0 1 1 0 1;... %4-2 d
                1 1 0 0 1 1;... %4-2 f
                1 1 1 0 0 0;... %3-3 g
                1 0 1 0 1 0];   %3-3 h
            
%specify probabilities
mazeProbs = [0.30/1;...  %a
             0.30/2;...  %b
             0.30/2;...  %c
             0.25/2;...  %d
             0.25/2;...  %f
             0.15/2;...  %g
             0.15/2];    %h
         
% %OPTION 5 - ADDS A CONDITION, PROBABLY NOT
% %specify patterns to test
%        %segment 1 2 3 4 5 6
% mazePatterns = [1 1 1 1 1 1;... %6-0 a
%                 0 1 1 1 1 1;... %5-1 b
%                 1 1 1 1 1 0;... %5-1 c
%                 1 1 0 1 1 1;... %5-1 d
%                 1 0 1 0 1 1;... %4-2 e
%                 1 0 1 1 0 1;... %4-2 f
%                 1 1 0 0 1 1;... %4-2 g
%                 1 1 1 0 0 0;... %3-3 h
%                 1 0 1 0 1 0];   %3-3 i
%             
% %specify probabilities
% mazeProbs = [0.25/1;...  %a
%              0.25/3;...  %b
%              0.25/3;...  %c
%              0.25/3;...  %d
%              0.25/3;...  %e
%              0.25/3;...  %f
%              0.25/3;...  %g
%              0.25/2;...  %h
%              0.25/2];    %i

nTrials = 1e6;
%%%%%%%%%%%%%%%%%%%%%%FUNCTION%%%%%%%%%%%%%%%%%%%%%%%%

%convert to logical
mazePatterns = logical(mazePatterns);

%duplicate for opposite side
mazePatterns = cat(1,mazePatterns,~mazePatterns);
mazeProbs = repmat(mazeProbs/2,2,1);

%check to make sure probabilities add up to 1
if sum(mazeProbs) < 0.99999999 || sum(mazeProbs) > 1.0000000001
    error('Maze probabilities do not add up to 1');
end

%get parameters
nMazes = length(mazeProbs);
nSeg = size(mazePatterns,2);

%generate trial types
trialTypes = randsample(length(mazeProbs),nTrials,true,mazeProbs);

%get trial patterns
trialPatterns = mazePatterns(trialTypes,:);

%get correct answers
correctTurns = sum(trialPatterns,2);
correctTurns(correctTurns < nSeg/2) = 0;
correctTurns(correctTurns > nSeg/2) = 1;
correctTurns(correctTurns == nSeg/2) = randi([0 1],sum(correctTurns...
    == nSeg/2),1);

%determine whether each segment agrees with correct turn
segPredict = trialPatterns == repmat(correctTurns,1,nSeg);

%get probabilities
probPredict = sum(segPredict)/size(segPredict,1);

%plot histogram
figH = figure;
scatter(1:nSeg,probPredict,'bo','filled','SizeData',200);
ylabel('Probability Segment Predicts Correct Answer','FontSize',25);
xlabel('Segment Number','FontSize',25);
set(gca,'XTick',0:6,'FontSize',20);
ylim([0 1]);
xlim([0.5 nSeg + 0.5]);



    
    
                
                