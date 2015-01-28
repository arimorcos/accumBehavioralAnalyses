function [sessionTime] = calcSessionTime(sessionTime);
[H M S MS] = strread(datestr(sessionTime,'HH:MM:SS:FFF'),'%d:%d:%d:%d'); %#ok<REMFF1>
    sessionTime = 60*H + M + S/60 + MS/60000;
end