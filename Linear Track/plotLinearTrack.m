function figHandle = plotLinearTrack(perf,anName,silent)
%function to plot linear track data

%get number of sessions
nSessions = length(perf.lengths);

%find number of subplots
squares = 1:10;
squares = squares.^2;
dist = squares - nSessions;
dist(dist < 0) = NaN;
[~,ind] = min(dist);


%plot
if silent
    figHandle = figure;
else
    figHandle = figure('visible','off');
end
for i=1:nSessions %for each session
    subplot(ind,ind,i); %create proper subplot
    plot(perf.lengths{i},'b','LineWidth',2);
    ylabel('Maze Length');
    xlabel(['Session ',num2str(i),' Trial #']);
end
mtit(anName);
    
end