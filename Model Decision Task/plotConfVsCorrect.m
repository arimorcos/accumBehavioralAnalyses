function plotConfVsCorrect(decision,correct)

%bin 
decision = abs(decision - 0.5);
binVals = 0:0.05:0.5;
roundDecision = roundtowardvec(decision,binVals);

%get means 
meanVals = nan(1,length(binVals));
for i = 1:length(binVals)
    if any(roundDecision == binVals(i))
        meanVals(i) = mean(correct(roundDecision == binVals(i)));
    end
end

% plot scatter 
figure;
axH = axes;
hold(axH,'on');

%plot 
scatter(decision, correct);

%plot mean 
plot(binVals, meanVals);

%lable
axH.XLabel.String = 'Confidence';
axH.YLabel.String = 'Fraction correct';

axH.FontSize = 20;