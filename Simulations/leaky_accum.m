cues = [1 -1 1;...
        -1 1 1];
    
cue_times = 10:10:30;
decay = 0.9;
num_time_points = 50;
noise_std = 0.01;

% generate noise 
noise = noise_std*randn(2, num_time_points);

% loop through and generate
traces = nan(2, num_time_points);
traces(:, 1) = 0;
for time = 2:num_time_points
    
    if ismember(time, cue_times)
        
        index = find(time == cue_times);
        traces(:, time) = traces(:, time - 1)*decay + ...
            cues(:, index) + noise(:, time);
    else
        traces(:, time) = traces(:, time - 1)*decay + noise(:, time);
    end
    
    
end


% plot 
figH = figure;
axH = axes; 

plot(1:num_time_points, traces);
%plot 