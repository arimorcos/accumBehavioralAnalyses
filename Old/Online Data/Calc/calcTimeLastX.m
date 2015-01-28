%calcTimeLastX.m

%function to calculate the elapsed time in minutes between the end of the
%last trial and the beginning of the trial X before it. In other words the
%total time of the last X trials. 

%ASM 6/13/12

function [elapTimeLastX elapTimeVec] = calcTimeLastX(timesLastX)
    
        elapTimeVec = timesLastX.trialEndTimes(end) - timesLastX.trialStartTimes(1);

        [H M S MS] = strread(datestr(elapTimeVec,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
        elapTimeLastX = 60*H + M + S/60 + MS/60000;

end