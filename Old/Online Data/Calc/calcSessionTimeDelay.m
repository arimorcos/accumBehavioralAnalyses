%calcSessionTimeDelay.m

%function to calculate the elapsed session time for each delay

%ASM 6/13/12

function [sessionTime] = calcSessionTimeDelay(times,data)
    
if ~isempty(times.trialEndTimes)
    sessionTime = times.trialEndTimes(end) - times.trialStartTimes(1);
else
    sessionTime = data(1,end) - data(1,1);
end
    
    [H M S MS] = strread(datestr(sessionTime,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
    sessionTime = 60*H + M + S/60 + MS/60000;

end