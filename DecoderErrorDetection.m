%Below txt includes 260 Steiner system element to be mapped as different users and their scheduled slot numbers.
Steiner = importdata('Steiner_3_5_26.txt');

numOfSlots = 26;
[m,n] = size(Steiner);
errorCounter = 0;

%numOfActiveUsers is calculated from poission dist
%it will be replaced later.
lambda = 3;
numOfActiveUsers = poissrnd(lambda);

%assign random RNTI numbers for active users between 1-260.
activeUserArray = zeros(numOfActiveUsers,1);
activeUserArray(:) = randperm(m,numOfActiveUsers);
rntiSum = sum(activeUserArray);
%slotVector to keep the scheduled RNTI numbers for the slots
slotVector = zeros(numOfSlots,numOfActiveUsers); % Initializing all the slots with 0 active user at the beginning.

%prepare scheduled slot vector from the userRntiwithScheduledSlotNumbers according to randomly chosen RNTI values
slotUeCnt = ones(numOfSlots,1);
for i=1:1:numOfActiveUsers
  currentRnti = activeUserArray(i);
  for j=1:1:n
    slotNumOfUe = Steiner(currentRnti,j);
    slotVector(slotNumOfUe, slotUeCnt(slotNumOfUe)) = currentRnti;
    slotUeCnt(slotNumOfUe) = slotUeCnt(slotNumOfUe)+1;
  end
end

%decoder to decode slots if there is no interference
%then update the slotVector after decoding to apply SIC
dontBreak = 1;
while dontBreak == 1
    dontBreak = 0;
    for i=1:1:numOfSlots
        if (nnz(slotVector(i,:)) == 1)
            rntiForActiveUser = sum(slotVector(i,:));
            slotVector( slotVector == rntiForActiveUser ) = 0;
            dontBreak = 1;
        end
    end
end

errorSum = sum(slotVector(:));
if errorSum > 0
    errorCounter = errorCounter + 1;
end
