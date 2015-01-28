function [durations] = calcDelayDur(dataCell,delayLength,delayBounds,crutchTrials)
%calcDelayDur.m calculates the duration of the delay for all trials and
%outputs them in the 1xnTrials array 'durations'
%
%dataCell - cell containing data (must contain .dat files)
%delayLength - criterion maze length. Will only analyze trials with this
%   length
%delayBounds - start and end for delay period
%crutchTrials - boolean of whether or not to include crutchTrials

dataSub = getTrials(dataCell,['maze.delayLength == ',num2str(delayLength)]); % get subset of trials with proper delay length
if ~crutchTrials %if not crutch trials, eliminate them
    dataSub = getTrials(dataSub,'maze.crutchTrial==0');
end

durations = zeros(1,length(dataSub)); %initialize array

for i = 1:length(dataSub) %for each trial
    
    %remove any trials in which mouse turned around before the end of the
    %segments
    yPos = dataSub{i}.dat(3,:);
    tempTheta = rad2deg(mod(dataSub{i}.dat(4,:),2*pi));
    if any(yPos > 0 & yPos < delayBounds(2) & tempTheta > 180)
        durations(i) = NaN;
        continue;
    end
    
    %get delay start time
    start = find(dataSub{i}.dat(3,:) >= delayBounds(1),1,'first');
    
    %get delay stop time
    stop = find(dataSub{i}.dat(3,:) <= delayBounds(2),1,'last');
    
    durations(i) = dnum2secs(dataSub{i}.dat(1,stop) - dataSub{i}.dat(1,start));
end

%remove nans
durations = durations(~isnan(durations));
