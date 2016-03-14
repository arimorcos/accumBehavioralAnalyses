load('AM131_good_behavior.mat');
[linear{1}, logistic{1}] = get_linear_poly(indDataCells);
load('AM136_good_behavior.mat');
[linear{2}, logistic{2}] = get_linear_poly(indDataCells);
load('AM142_good_behavior.mat');
[linear{3}, logistic{3}] = get_linear_poly(indDataCells);
load('AM144_good_behavior.mat');
[linear{4}, logistic{4}] = get_linear_poly(indDataCells);
load('AM150_good_behavior.mat');
[linear{5}, logistic{5}] = get_linear_poly(indDataCells);


save('linear_logistic.mat', 'linear','logistic');