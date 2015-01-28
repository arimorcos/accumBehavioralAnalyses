function [out] = lastSegment(dataCell)
%lastSegment.m function to analyze whether last segment influences behavior
%more than other segments.

numTrialsOtherSeg = 0;
numRewardsOtherSeg = 0;
numTrialsLastSeg = 0;
numRewardsLastSeg = 0;
numTurnLastSeg = 0;

for i=1:length(dataCell) %for each trial
    if (dataCell{i}.maze.whiteTrial && ~ismember(8,dataCell{i}.maze.whiteDots)) ||...
            (~dataCell{i}.maze.whiteTrial && ismember(8,dataCell{i}.maze.whiteDots))...
            %if trial is white and the last segment is black or if
            %trial is black and the last segment is white
            numTrialsLastSeg = numTrialsLastSeg + 1; %add a trial
            if dataCell{i}.result.correct
                numRewardsLastSeg = numRewardsLastSeg + 1;
            end
            if dataCell{i}.maze.whiteTrial && dataCell{i}.result.whiteTurn
    else
        numTrialsOtherSeg = numTrialsOtherSeg + 1;
        if dataCell{i}.result.correct
            numRewardsOtherSeg = numRewardsOtherSeg + 1;
        end
    end
    
    if (ismember(8,dataCell{i}.maze.whiteDots) && dataCell{i}.result.whiteTurn) ||...
            (~ismember(8,dataCell{i}.maze.whiteDots) && ~dataCell{i}.result.whiteTurn)...
            %if mouse turned toward white and white was the last segment or
            %turned toward black and black was last segment
            numTurnLastSeg = numTurnLastSeg + 1;
    end
    
        
end

out.percCorrLastSeg = numRewardsLastSeg/numTrialsLastSeg;
out.percCorrOtherSeg = numRewardsOtherSeg/numTrialsOtherSeg;
out.percTurnLastSeg = numTurnLastSeg/length(dataCell);
out.percTurnInt = sum(getCellVals(dataCell,'result.correct'))/length(dataCell);
out.maxPossLastSeg = numTrialsOtherSeg/length(dataCell);

end