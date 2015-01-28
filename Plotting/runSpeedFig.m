color = hsv(length(fieldnames(cumRunData)));

figure;
hold on;

names = fieldnames(cumRunData);

data = [];
dataLabels = {};
for i=1:length(fieldnames(cumRunData))
    data(1,size(data,2)+1:size(data,2)+size(cumRunData.(char(names(i))).data,2)) = cumRunData.(char(names(i))).data;
    dataLabels(1,size(dataLabels,2)+1:size(dataLabels,2)+size(cumRunData.(char(names(i))).data,2)) = names(i);
end

boxplot(data,dataLabels,'jitter',0.5);

ylabel('Run Speed (units/sec)');


