function fitDecisionTaskOrchestra(nSeeds, dataLoc)

%load train data
fprintf('Loading data...\n');
load(dataLoc,'trainData');
fprintf('Loaded data\n');

%initialize orchestra
fprintf('Initializing cluster...');
jm = parallel.cluster.LSF();
fprintf('Complete\n');

%create job
fprintf('Creating jobs and submitting arguments...');
job=createJob(jm);

%set arguments
set(jm, 'SubmitArguments', '-W 30 -q mcore -n 4 -o -workerDump');
set(jm,'ClusterMatlabRoot','/opt/matlab');
fprintf('Complete\n');

%initialize saveFile 
saveFileTXT = sprintf('/home/asm27/decisionTaskOut/decisionTaskFit-%s.txt',datestr(now,'yymmdd-HHMMSS'));
saveFileMat = sprintf('/home/asm27/decisionTaskOut/decisionTaskFit-%s.mat',datestr(now,'yymmdd-HHMMSS'));
if exist(saveFileTXT,'file')
    delete(saveFileTXT);
end
if exist(saveFileMat,'file')
    delete(saveFileMat);
end

fprintf('Creating tasks...');
%create tasks
for seedNum = 1:nSeeds
    
    %create task
    createTask(job, @runDecisionTaskOrchestra, 1, {trainData, saveFileTXT});
    fprintf('%d...\n',seedNum);
    
end

fprintf('Complete\n');

%submit the job
submit(job)

%wait for job to finish
fprintf('Waiting...');
wait(job,'finished')
fprintf('done\n');
job.State

task = findTask(job);
message = getDebugLog(jm, task(1))

%fetch outputs
data = fetchOutputs(job);
fprintf('Fetched output\n');

%save
save(saveFileMat,'data');
fprintf('Complete\n');

destroy(job);

end

