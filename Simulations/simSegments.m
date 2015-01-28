nTrials = 10000; 
fracCorr = 1; 
nSegs = 8;

messSeg = [1 4];
messSegProb = .8;

mazeDesign = zeros(nTrials,nSegs);
result = zeros(nTrials,1);
color = zeros(nTrials,1);
turn = zeros(nTrials,1);
for i=1:nTrials %for each trial
    
    nWhite = randi([0 nSegs]);
    whiteSegs = sort(randsample(8,nWhite));
    mazeDesign(i,whiteSegs) = 1;
    if rand <= messSegProb 
        mazeDesign(i,messSeg) = 0;
    end
    
    if rand <= fracCorr
        result(i) = 1;
    end
        
    if nWhite > 4
        color(i) = 1;
    elseif nWhite == 4
        color(i) = randi([0 1]);
    end
    
    if result(i) && color(i) %if correct and white
        turn(i) = 1;
    elseif ~result(i) && ~color(i) %if wrong and black
        turn(i) = 1;
    end
end

segCorr = zeros(1,nSegs);
for i=1:nSegs %for each segment
    for j=1:nTrials
        if mazeDesign(j,i) == color(j) && result(j)
            segCorr(i) = segCorr(i) + 1;
        end
    end
end
segPercCorr = 100*segCorr/nTrials;


figure;
subplot(1,2,1);
hist(sum(mazeDesign,2));
ylabel('nTrials');
xlabel('# White Segments');

subplot(1,2,2);
scatter(1:8,segPercCorr);
ylim([0 100]);
xlim([1 8]);
ylabel('Percent Turns Toward Segment Color');
xlabel('Segment Number');
disp(['Mean Percent Turns Toward Segment Color: ',num2str(mean(segPercCorr,2))]);


