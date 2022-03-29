% Initialize the parallel pool
c=parcluster();

% Create a temporary folder for the workers working on this job,
% in order not to conflict with other jobs.
t=tempname();
mkdir(t);

% set the worker storage location of the cluster
c.JobStorageLocation=t;

% get the number of workers based on the available CPUS from SLURM
num_workers = str2double(getenv('SLURM_CPUS_PER_TASK'));

% start the parallel pool
parpool(c,num_workers);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Steiner = importdata('Steiner_3_5_26.txt');
numOfSlots = 26;    


loop_cnt = 10^8;
max_users = 80;
results = zeros(1,max_users);
tic
parfor numOfActiveUsers = 1:1:max_users
errorCounter = 0;
for iteration = 1:loop_cnt
slotVector = zeros(numOfSlots,numOfActiveUsers);
S = Steiner(randsample(260, numOfActiveUsers),:);
for i=1:1:numOfActiveUsers
    slotVector(S(i,:),i) = ones(5,1);
end
while 1
    rowsums = sum(slotVector,2);
    indicatorvec = (2*rowsums - 1).^2;
    indicatormat = repmat(indicatorvec,1,numOfActiveUsers);
    quot = floor(slotVector./indicatormat);
    [rows, cols] = find(quot);
    cols = unique(cols);
    a = size(cols);
    if a(1) == 0
        break
    end
    slotVector(:,cols(:)) = zeros(26,a(1));
end
if any(slotVector)
    errorCounter = errorCounter + 1;
end
end
results(numOfActiveUsers)=errorCounter;
end
toc

pythonstring = strcat('[', num2str(results(1)));
for i=2:1:length(results)
    pythonstring = strcat(pythonstring, ', ', num2str(results(i)));
end
pythonstring = strcat(pythonstring, ']');
disp(pythonstring);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Exit the program
exit(0)
