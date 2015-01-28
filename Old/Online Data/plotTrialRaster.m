%plotTrialRaster

%function to plot trial raster plot

function plotTrialRaster(procData)
    
        
    %plot trial conditions
    subplot('Position',[0.05 0.64 0.9 0.03]);
    cla reset;
    xlabel('Window End Time');
    set(gca,'YTickLabel','','YTick',[]);
    load('MyColormaps.mat','blackGreyColor');
    cmapCustom(1,:) = blackGreyColor(1,:);
    for i = 2:max(procData.trialList(2,:))
        cmapCustom(i,:) = blackGreyColor(i*round(size(blackGreyColor,1)/max(procData.trialList(2,:))),:);
    end
    for i=1:size(procData.trialList,2)
        rasterHandle(i) = line([procData.trialList(1,i)/procData.totTime procData.trialList(1,i)/procData.totTime],[0 1]);
        set(rasterHandle(i),'Color',cmapCustom(procData.trialList(2,i),:),'LineWidth',3);
    end
    xlim([0 1]);
    xTickVals = num2cell(procData.plotTimes(round(linspace(1,length(procData.plotTimes),11))));
    xTickDates = cellfun(@(x) datestr(x,'HH:MM:SS'),xTickVals,'UniformOutput',false);
    set(gca,'XTickLabel',xTickDates);
    
    if isfield(procData,'scaleFacAll')
        hold on;
        xTimes = (1:procData.totTime)/procData.totTime;
        plot(xTimes,procData.scaleFacAll,'b','LineWidth',2);
        plot(xTimes,procData.lengthFacAll-1,'r','LineWidth',2);
    end  
    
    if isfield(procData,'greyFacAll')
        hold on;
        xTimes = (1:procData.totTime)/procData.totTime;
        plot(xTimes,procData.greyFacAll,'b','LineWidth',2);
        if min(procData.greyFacAll) == max(procData.greyFacAll)
            ylim([min(procData.greyFacAll) min(procData.greyFacAll)+0.01]);
        else
            ylim([min(procData.greyFacAll) max(procData.greyFacAll)]);
        end
        set(gca,'YTickLabelMode','auto','YTickMode','auto','YAxisLocation','right');
    end 
    
    %create trial cond legend
    subplot('Position',[0.02 0.6025 0.9 0.0175]); 
    cla reset;
    set(gca,'visible','off');
    xlim([0 1]);
    for i = 1:size(cmapCustom,1)
        line([i/24 i/24],[0 1],'Color',cmapCustom(i,:),'LineWidth',3);
        text(.0417*i+.01,.5,num2str(i),'Color',cmapCustom(i,:),'HorizontalAlignment','Left');
    end
end