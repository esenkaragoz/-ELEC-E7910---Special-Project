%This code checks how many active users in the vector element and update the vector after decoding the users

numOfSlots      = 26;
numOfMaxActUser = 3; % number of maximum active user in a slot according to the Steiner system
vector = zeros(numOfSlots,1); % Initializing all the slots with 0 active user at the beginning.

%Number of active users update according to the scheduler
for i=1:1:numOfSlots
    vector(i,1) = randi([0 5],1); %randomly generated number of active users in the slots.
end

%decoder to check how many active users in the slot and update the vector
%after decode the users
for k=1:1:numOfSlots
    if vector(k,1) > numOfMaxActUser
        fprintf("There is an interference in the %d . slot and number of shceduled user is %d\n", k, vector(k,1));
    else
        vector(k,1) = 0;
    end
end
