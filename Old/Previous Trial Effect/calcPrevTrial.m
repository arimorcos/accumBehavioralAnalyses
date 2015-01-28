%calcPrevTrial.m

%function to look at previous trials and calculate probability of turn in
%same fashion

function [prevRes] = calcPrevTrial(data,win)
    
    if size(data.turnList,2) > win
        for i = (win+1):size(data.turnList,2) 
            numLeftTrials(i) = sum(data.turnList(4,(i-win):(i-1))); %#ok<*AGROW>
            numWhiteTrials(i) = sum(data.turnList(5,(i-win):(i-1)));
%             numLeftTurns(i) = sum(data.turnList(2,(i-win):(i-1)));
%             numWhiteTurns(i) = sum(data.turnList(3,(i-win):(i-1)));
            testTurnsWhite(i) = data.turnList(3,i);
            testTurnsLeft(i) = data.turnList(2,i);
        end
        probLeftTrialWin = numLeftTrials/win;
        probWhiteTrialWin = numWhiteTrials/win;  
        for i = 2:2:10
            if i == 2
                prevRes.binnedProbLeft(i/2) = mean(testTurnsLeft(probLeftTrialWin >= (i-2)/10 & probLeftTrialWin <= .1*i));
                prevRes.binnedProbWhite(i/2) = mean(testTurnsWhite(probWhiteTrialWin >= (i-2)/10 & probWhiteTrialWin <= .1*i));
            else
                prevRes.binnedProbLeft(i/2) = mean(testTurnsLeft(probLeftTrialWin > (i-2)/10 & probLeftTrialWin <= .1*i));
                prevRes.binnedProbWhite(i/2) = mean(testTurnsWhite(probWhiteTrialWin > (i-2)/10 & probWhiteTrialWin <= .1*i));
            end
        end
    else
        message('Window too large');
    end

end