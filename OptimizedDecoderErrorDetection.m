tic
loop_cnt = 1000;
while(loop_cnt ~= 0)
    error_detection();
    loop_cnt = loop_cnt-1;
end
toc

function [] = error_detection()
%Below txt includes 260 Steiner system element to be mapped as different users and their scheduled slot numbers.
Steiner = importdata('Steiner_3_5_26.txt');

numOfSlots = 26;
[m,n] = size(Steiner);
             
%poisson distribution will be used to determine number of active users in the slots.
%The range for lambda will be decided later. it is 3 for now.
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

%decoder to decode slots if there is no interference update the slotVector after decoding
for i=1:1:numOfSlots
    actUserNum = slotUeCnt(i)-1;
    if (actUserNum == 1)
        %If there is only 1 UE in the slot, sum of all rows in i. column will be equal to the RNTI of that user.
        rntiForActiveUser = sum(slotVector(i,:));
        rntiSum = rntiSum - rntiForActiveUser;
        if (rntiSum == 0)
            return;
        end
        %Apply SIC, search for decoded user and remove it from upcoming slot lists.
        for k=i+1:1:numOfSlots
            for l=1:1:numOfActiveUsers
                if slotVector(k,l) == rntiForActiveUser
                    slotVector(k,l) = 0;
                    slotUeCnt(k) = slotUeCnt(k)-1;
                end
            end
        end
    end
end

errorSum = sum(slotVector(:));
if errorSum > 0
    fprintf("Test failed, numOfActiveUsers = %d \n", numOfActiveUsers);
end
end
