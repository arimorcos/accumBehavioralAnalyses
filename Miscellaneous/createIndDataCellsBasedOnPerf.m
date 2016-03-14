function createIndDataCellsBasedOnPerf(mouse)

perf_folder = '/mnt/7A08079708075215/DATA/Analyzed Data/160217_mouse_perf';
data_path = '/mnt/7A08079708075215/DATA/Ari/Archived Mice';

%set thresh
thresh60 = 0.82;
thresh51 = 0.75;
thresh42 = 0.6;

% max num
max_cells = 15;


%open folder 
fid = fopen(fullfile(perf_folder, [mouse, '.txt']), 'r');

% loop through 
match_list = {};
store_lines = {};
score = [];
tline = fgetl(fid);
exp = '^File: (.*.mat) | 6-0: (\d.\d\d) | 5-1: (\d.\d\d|NaN) | 4-2: (\d.\d\d|NaN) | 3-3: (\d.\d\d|NaN)';
while ischar(tline)
   match = regexp(tline, exp, 'tokens');
   if str2double(match{2}{1}) > thresh60 && ...
           str2double(match{3}{1}) > thresh51 && ...
           str2double(match{4}{1}) > thresh42
%        fprintf('%s \n', tline);
       temp_score = nansum([str2double(match{2}{1}), ...
           str2double(match{3}{1}), ...
           str2double(match{4}{1}), ...
           str2double(match{5}{1})]);
       score = cat(1, score, temp_score);
       match_list = cat(1, match_list{:}, match{1}(1));
       store_lines = cat(1, store_lines{:}, {tline});
   end
   tline = fgetl(fid);
end
fclose(fid);

%sort 
[~, sort_order] = sort(score, 'descend');
match_list = match_list(sort_order);
store_lines = store_lines(sort_order);

if length(match_list) < max_cells
    max_cells = length(match_list);
end

%crop 
match_list = match_list(1:max_cells);
% store_lines = store_lines(1:max_cells);



%load and save 
indDataCells = cell(max_cells, 1);
for file = 1:max_cells
    load(fullfile(data_path, mouse, match_list{file}), 'dataCell');
    
    %reset dataCell
    dataCell = resetDataCellImaging(dataCell);
    
    %store 
    indDataCells(file) = {dataCell};
end

%save 
save(fullfile(perf_folder, [mouse, '_good_behavior.mat']), 'indDataCells');
