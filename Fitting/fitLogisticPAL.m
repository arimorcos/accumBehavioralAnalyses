function [alpha,beta,xValsFit,yValsFit] = fitLogisticPAL(xVals,numTurns,numTrials)
%fitLogisticPAL.m Function to fit a logistic function to data using maximul
%likelihood method
%
%INPUTS
%xVals - x values
%numTurns - numTurns toward white or left
%numTrials - total opportunities to turn toward white or left
%
%OUTPUTS
%alpha - threshold
%beta - slope
%xValsFit - x values for fit curve
%yValsFit - y values for fit curve
%
%ASM 7/14

%Parameter grid defining parameter space through which to perform a
%brute-force search for values to be used as initial guesses in iterative
%parameter search.
searchGrid.alpha = 0:0.5:6;
searchGrid.beta = logspace(-1,3,100);
fracCorr = numTurns./numTrials;
searchGrid.gamma = fracCorr(1);  %scalar here (since fixed) but may be vector
% searchGrid.lambda = 0.01;  %ditto
searchGrid.lambda = mean([fracCorr(1) 1-fracCorr(end)]); %lapse rate is average incorrect rate on 6-0

%Threshold and Slope are free parameters, guess and lapse rate are fixed
paramsFree = [1 1 0 0];  %1: free parameter, 0: fixed parameter
 
%Fit a Logistic function
PF = @PAL_Logistic;  %Alternatives: PAL_Gumbel, PAL_Weibull, 
                     %PAL_CumulativeNormal, PAL_HyperbolicSecant

%Optional:
options = PAL_minimize('options');   %type PAL_minimize('options','help') for help
options.TolFun = 1e-09;     %increase required precision on LL
options.MaxIter = 100;
options.Display = 'off';    %suppress fminsearch messages

%run fit
[paramsValues, ~, ~, ~] = PAL_PFML_Fit(xVals,numTurns,...
    numTrials,searchGrid,paramsFree,PF,'searchOptions',options);

%store alpha and beta
alpha = paramsValues(1);
beta = paramsValues(2);

%get new fit values
xValsFit = xVals(1):0.001:xVals(end);
yValsFit = PF(paramsValues,xValsFit);