Steiner = importdata('Steiner_3_5_26.txt');
numOfSlots = 26;    

tic
loop_cnt = 10^9;
results = [];
for lambda = 0.025:0.025:0.25
errorCounter = 0;
parfor iteration = 1:loop_cnt

numOfActiveUsers = poissrnd(lambda);
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
end
results=[results,errorCounter];
disp(results)
toc
