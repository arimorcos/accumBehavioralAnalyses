%getTrialStartEndTimes.m

%function which goes through data array and finds the indices of the trial
%start and end times

function [times] = getTrialStartEndTimes(data)
    itiTimesEnd = find(data(9,:)==1)-1; %find all the indices when in ITI and subtract one
    itiTimesStart = find(data(9,:)==1)+1;
    if ~isempty(itiTimesStart) && itiTimesStart(end) > size(data,2)
        itiTimesStart(end)=[];
    end
    times.trialEndTimesIndex = itiTimesEnd(find(data(9,itiTimesEnd)==0)); %#ok<FNDSB>
    times.trialStartTimesIndex = cat(2,1,itiTimesStart(find(data(9,itiTimesStart)==0))); %#ok<FNDSB>
    if data(9,end)==0
        times.trialStartTimesIndex(end) = []; %remove last start point because trial doesn't finish
    end
    times.trialStartTimes = data(1,times.trialStartTimesIndex);
    times.trialEndTimes = data(1,times.trialEndTimesIndex); 
end