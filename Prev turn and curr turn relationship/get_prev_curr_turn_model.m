function [model, interactions_model] = get_prev_curr_turn_model(dataCell)
% calculates a linear model based on the previous reward and turn.

prev_turn = getCellVals(dataCell, 'result.prevTurn');
prev_reward = getCellVals(dataCell, 'result.prevCorrect');
curr_turn = getCellVals(dataCell, 'result.leftTurn');

% create table 
tbl = table(prev_turn', prev_reward', curr_turn');

% create model 
model = fitlm(tbl);
interactions_model = fitlm(tbl, 'interactions');