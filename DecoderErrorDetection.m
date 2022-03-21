%Below txt includes 260 Steiner system element to be mapped as different users and their scheduled slot numbers.
Steiner = importdata('Steiner_3_5_26.txt');

numOfSlots = 26;
[m,n] = size(Steiner);
%n+1 because I want to reserve 1 column for RNTI numbers and
%next 5 columns for scheduled slot numbers for those users
userRntiwithScheduledSlotNumbers = zeros(m,n+1); %initialize
                                                                                                       
%to assign RNTI number from 1 to 260
userRntiwithScheduledSlotNumbers(:,1) = linspace(1, m, m);
%to assign scheduled slot numbers from Steiner System to users
userRntiwithScheduledSlotNumbers(1:m,2:n+1) = Steiner(1:m,1:n);

%poisson distribution will be used to determine number of active users in the slots.
%The range for lambda will be decided later. it is 3 for now.
lambda = 3;
numOfActiveUsers = poissrnd(lambda);

%assign random RNTI numbers for active users between 1-260.
activeUserArray = zeros(numOfActiveUsers,1);
activeUserArray(:) = randperm(m,numOfActiveUsers);

%slotVector to keep the scheduled RNTI numbers for the slots
slotVector = zeros(numOfSlots,50); % Initializing all the slots with 0 active user at the beginning.

%prepare scheduled slot vector from the userRntiwithScheduledSlotNumbers according to randomly chosen RNTI values
slotUeCnt = ones(numOfSlots,1);
for i=1:1:size(activeUserArray)
  currentRnti = activeUserArray(i);
  for j=2:1:n+1
    slotNumOfUe = userRntiwithScheduledSlotNumbers(currentRnti,j);
    slotVector(slotNumOfUe, slotUeCnt(slotNumOfUe)) = currentRnti;
    slotUeCnt(slotNumOfUe) = slotUeCnt(slotNumOfUe)+1;
  end
end

%decoder to decode slots if there is no interference update the slotVector after decoding
for i=1:1:numOfSlots
    actUserNum = slotUeCnt(i)-1;
    if (actUserNum == 1)

        rntiForActiveUser = 0;
        %If there is only 1 UE in the slot, sum of all rows in i. column will be equal to the RNTI of that user.
        for j=1:1:50
            rntiForActiveUser = rntiForActiveUser + slotVector(i,j);
        end

        %Apply SIC, search for decoded user and remove it from upcoming slot lists.
        for k=i+1:1:numOfSlots
            for l=1:1:50
                if slotVector(k,l) == rntiForActiveUser
                    slotVector(k,l) = 0;
                    slotUeCnt(k) = slotUeCnt(k)-1;
                end
            end
        end
        %search the decoded user in the previous slots as well and remove it.
        if i>2
            for t=i-1:-1:1
                for s=1:1:50
                    if slotVector(t,s) == rntiForActiveUser
                        slotVector(t,s) = 0;
                    end
                end
            end
        end
        for p=1:1:50
            slotVector(i,p) = 0; %remove the user also from the current slot.
        end
    end
end

%now check the slotVector at the end and see if there is leftover user who cannot be decoded because of the interference.
errorSum = 0;
for z=1:1:numOfSlots
    for y=1:1:50
        errorSum = errorSum + slotVector(z,y);
    end
end

if errorSum > 0
    fprintf("Test failed");
end
