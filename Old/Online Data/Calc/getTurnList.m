%getTurnList.m

%function to create an array with of all turns and whether they were left
%or right. First row is indices and second row is left or not (1 or 0,
%respectively). Third row is white turn or not. Fourth row is whether
%correct answer is left or not. Fifth row is whether correct answer is
%white or not.

%ASM 6/15/12

function [turnList] = getTurnList(data,leftMazes,whiteMazes,times)
    
    turnList(1,:) = times.trialEndTimesIndex;
    rew = zeros(1,length(times.trialEndTimesIndex));
    cond = zeros(1,length(times.trialEndTimesIndex));
    
    for i=1:length(times.trialEndTimesIndex)
        rew(i) = data(8,times.trialEndTimesIndex(i)+1) ~= 0;
        cond(i) = data(7,times.trialEndTimesIndex(i));
        
        if leftMazes(cond(i)) == 1 %determine whether a left turn was made
            if rew(i) == 1
                turnList(2,i) = 1;
            else
                turnList(2,i) = 0;
            end
            turnList(4,i) = 1;
        else
            if rew(i) == 1
                turnList(2,i) = 0;
            else
                turnList(2,i) = 1;
            end
            turnList(4,i) = 0;
        end
        
        if whiteMazes(cond(i)) == 1 %determine whether a white turn was made
            if rew(i) == 1
                turnList(3,i) = 1;
            else
                turnList(3,i) = 0;
            end
            turnList(5,i) = 1;
        else
            if rew(i) == 1
                turnList(3,i) = 0;
            else
                turnList(3,i) = 1;
            end
            turnList(5,i) = 0;
        end
        
    end
end
    
%     for i=1:length(leftMazes)
%         condTrialInd = times.trialEndTimesIndex(data(7,times.trialEndTimesIndex) == i);
%         condRewInd = condTrialInd(data(8,condTrialInd+1) ~= 0);
%     end
