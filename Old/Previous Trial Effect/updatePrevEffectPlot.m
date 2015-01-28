%updatePrevEffectPlot.m

%function to update previous effect plot

function updatePrevEffectPlot(src,evnt,prevGUI,data)
    
    subplot('Position',[0.05 0.2 0.9 0.7]);
    cla reset;
    

    
    win = str2double(get(prevGUI.winSize,'String'));
    
    [prevRes] = calcPrevTrial(data,win);
    
    %plot
    plot(0.2:0.2:1,prevRes.binnedProbLeft,'b-o','MarkerSize',10,'MarkerFaceColor','b');
    hold on;
    plot(0.2:0.2:1,prevRes.binnedProbWhite,'r-x','MarkerSize',10,'MarkerFaceColor','r');
    legend('Left','White');
    title(['Effect of Previous Trials on Turning: Window Size - ',num2str(win)]);
    xlabel(['Probability of Previous ', num2str(win),' Being Left/White']);
    ylabel('Proability of Turn on Test Trial Toward Left/White');
    xlim([0 1]);
    ylim([0 1]);
    
    axis square;
    
end