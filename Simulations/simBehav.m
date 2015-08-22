function simBehav(segDetect)


nTest = 10000;

type = nan(nTest,1);
turn = nan(nTest,1);

for test = 1:nTest
    
    %generate type 
    pattern = randsample([-1 1],6,true);
    type(test) = sum(pattern==1);
    
    %perform accumulation 
    guess = 0;
    for i = 1:6
        if rand < segDetect
            guess = guess + pattern(i);
        else 
            guess = guess - pattern(i);
        end
    end
    
    %store 
    if guess > 0 
        turn(test) = 1;
    elseif guess < 0 
        turn(test) = 0;
    else
        turn(test) = randi([0 1]);
    end
    
end

%calculate 
vals = nan(1,7);
for i = 1:7
    
    %keep trials 
    keepTrials = type == i-1;
    
    %take mean turn 
    vals(i) = mean(turn(keepTrials));
    
end

%plot 
figH = figure;
axH = axes;

%scatter 
scatH = scatter(0:6,100*vals,150,'b','filled');

%beautify
beautifyPlot(figH,axH);

axH.YLim = [0 100];

%label
axH.XLabel.String = 'Number left cues';
axH.YLabel.String = 'Percent turns toward left';