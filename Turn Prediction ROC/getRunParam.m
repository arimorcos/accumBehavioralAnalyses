function [out, segmented] = getRunParam(dataCell,ranges)

%initialize arrays
theta = cell(1,length(dataCell));
xVel = cell(size(theta));
evArray = cell(size(theta));
yPos = cell(size(theta));
turnArray = cell(size(theta));
trialID = cell(size(theta));
if isfield(dataCell{1}.maze,'numLeft')
    out.numSeg = max(getCellVals(dataCell,'maze.numLeft'));
    segmented = true;
else
    segmented = false;
end

for i=1:length(dataCell) %for each trial
    
    %remove any trials in which mouse turned around before the end of the
    %segments
    yPos{i} = dataCell{i}.dat(3,:);
    tempTheta = rad2deg(mod(dataCell{i}.dat(4,:),2*pi));
    if any(yPos{i} > ranges(1) & yPos{i} < ranges(end) & tempTheta > 180)
        theta{i} = nan(size(yPos{i}));
        xVel{i} = nan(size(yPos{i}));
        evArray{i} = nan(size(yPos{i}));
        yPos{i}(:) = NaN;
        turnArray{i} = nan(size(yPos{i}));
        trialID{i} = nan(size(yPos{i}));
        continue;
    else
        theta{i} = tempTheta;
    end
    
    %store trial id
    trialID{i} = i*ones(size(yPos{i}));
    
    %get xVelocity
    xVel{i} = dataCell{i}.dat(5,:);
    
    %for each virmen iteration, determine how many pieces of evidence in
    %favor of the correct answer the mouse has seen
    
    if segmented
        %first create an array containing the amount of evidence after each
        %range
        evRange = zeros(1,out.numSeg);
        if dataCell{i}.maze.leftTrial %if a left trial 
            evRange(dataCell{i}.maze.leftDotLoc) = 1;
            evRange = cumsum(evRange);
        else
            evRange(setdiff(1:out.numSeg,dataCell{i}.maze.leftDotLoc)) = 1;
            evRange = cumsum(evRange);
        end

        %next expand based on position
        evArray{i} = zeros(size(xVel{i}));
        for j=1:out.numSeg %for each segment
            if j < out.numSeg %if j is less than numSeg, find all indices in which current range
                ind = yPos{i} >= ranges(j) & yPos{i} < ranges(j+1);
            else %otherwise find all indices from last range to end
                ind = yPos{i} >= ranges(j);
            end
            evArray{i}(ind) = evRange(j);
        end
    else
        evArray{i} = nan(size(yPos{i}));
    end
    
    %create turn array which has the eventual turn at each point
    if dataCell{i}.result.leftTurn  %if mouse turned left
        turnArray{i} = ones(size(xVel{i})); %set all values of logical to 1
    else
        turnArray{i} = zeros(size(xVel{i}));
    end
    
    %center theta at 0
    theta{i} = 90 - theta{i};
    
    %store trial ID
    
end

out.evArray = evArray;
out.thetaArray = theta;
out.xVelArray = xVel;
out.yPosArray = yPos;
out.turnArray = turnArray;
out.trialIDArray = trialID;

evArrayAll = [evArray{:}];
thetaAll = [theta{:}];
xVelAll = [xVel{:}];
yPosAll = [yPos{:}];
turnAll = [turnArray{:}];
trialIDAll = [trialID{:}];

%remove nans
out.evArrayAll = evArrayAll(~isnan(evArrayAll));
out.thetaAll = thetaAll(~isnan(thetaAll));
out.xVelAll = xVelAll(~isnan(xVelAll));
out.yPosAll = yPosAll(~isnan(yPosAll));
out.turnAll = turnAll(~isnan(turnAll));
out.trialIDAll = trialIDAll(~isnan(trialIDAll));

end