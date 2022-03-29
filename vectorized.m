Steiner = importdata('Steiner_3_5_26.txt');
numOfSlots = 26;    


loop_cnt = 10^3;
max_users = 80;
results = zeros(1,max_users);
tic
parfor numOfActiveUsers = 1:1:max_users %0.025:0.025:0.25
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
