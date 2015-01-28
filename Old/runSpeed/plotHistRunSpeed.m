%plotHistRunSpeed.m

%function to plot histograms for run and turn speed calculations

function plotHistRunSpeed(runData,turnData)
    figure;
    
    subplot(2,2,1);
    hist(runData.secs,50);
    xlim([0 20]);
    title('Run Speed 25% to 75%')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(runData.secs,50);
    
    subplot(2,2,2);
    hist(turnData.secs,50);
    xlim([0 20]);
    title('Turn Speed Overall')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secs,50);
    
    subplot(2,2,3);
    hist(turnData.secsLeft,50);
    xlim([0 20]);
    title('Turn Speed Left')
    ylabel('Number');
    xlabel('Time (s)');
    
    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secsLeft,50);
    
    subplot(2,2,4);
    hist(turnData.secsRight,50);
    xlim([0 20]);
    title('Turn Speed Right')
    ylabel('Number');
    xlabel('Time (s)');

    pos = get(gca,'Position');
    pos(1) = pos(1) + .4*pos(3);
    pos(2) = pos(2) + .4*pos(4);
    pos(3:4) = 0.6*pos(3:4);
    axes('OuterPosition',pos);
    hist(turnData.secsRight,50);
    
    %get strings and find common input
    input1 = inputname(1);
    input2 = inputname(2);
    [~, ~, common] = LCS(input1, input2);
    set(gcf,'Name',['Run and Turn Data -- ',common(7:end)],'NumberTitle','off');
    
end