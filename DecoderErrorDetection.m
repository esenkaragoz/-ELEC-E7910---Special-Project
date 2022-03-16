%Below txt includes 260 Steiner system element to be mapped as different users and their scheduled slot numbers.
Steiner = importdata('Steiner_3_5_26.txt');

numOfSlots = 26;
numOfMaxActUser = 3; % number of maximum active user should be exist in a slot.
[m,n] = size(Steiner);
userRntiwithScheduledSlotNumbers = zeros(m,n+1); %initialize- n+1 because I want to reserve 1 column for RNTI numbers and 
                                                 %next 5 columns for scheduled slot numbers
                                               
%to assign each Steiner System element to different users as a RNTI
userRntiwithScheduledSlotNumbers(:,1) = linspace(1, m, m); %assigning increasing number from 1 to 260
%to assign scheduled slot numbers from Steiner System to users
userRntiwithScheduledSlotNumbers(1:m,2:n+1) = Steiner(1:m,1:n);

%there can be so many active users in the system(can not be known) but ideal one should be 3
%according to the Steiner system(at least idea is that it should be possible to decode 3 active
%user for 3_5_26). I created vector array for 5 users for now.In the vector array: 
%1st column to keep how many active users in that slot
%2nd, 3rd, 4th, 5th, and 6th columns to keep the RNTI numbers of these active users
vector = zeros(numOfSlots,n+1); % Initializing all the slots with 0 active user at the beginning.

%number of active users update in the scheduler
%It will be replaced with poisson distribution next
for i=1:1:numOfSlots
    vector(i,1) = randi([1 n],1); %randomly generated number of active users in the slots.
    vector(i,2:vector(i,1)+1) = randperm(m,vector(i,1)); %assign random & unique RNTI numbers for active users.
end

%decoder to check how many active users in the slot and update the vector after decode the users & apply SIC concept
ue_set = zeros(260,1);
for i=1:1:numOfSlots
    numOfActUsers = vector(i,1);
    for j = 2:1:numOfActUsers+1
        if ue_set(vector(i,j)) == 1
            del_cnt = 1;
            fprintf("deleted rnti %d from slot %d\n",vector(i,j), i);
            for k = j+1:1:numOfActUsers+1
                if ue_set(vector(i,k)) ~= 1
                    vector(i,k-del_cnt) = vector(i,k); %to shift the RNTI values in the vector  after deleting decoded users
                    ue_set(vector(i,j)) = 1;
                else
                    del_cnt = del_cnt+1;
                    fprintf("deleted rnti %d from slot x %d\n",vector(i,k), i);
                end
            end
            vector(i,1) = vector(i,1) - del_cnt; %to reduce the active user number in the slot
            break;
        end
        ue_set(vector(i,j)) = 1;
    end
end

%now the vector array that keeps number of active users and their RNTI
%values are different array than userRntiwithScheduledSlotNumbers array.
%How to correlate these two array?

%I believe SIC concept could happen if I remove already decoded users from
%userRntiwithScheduledSlotNumbers array(from upcoming slots) after decoding
%the users.
