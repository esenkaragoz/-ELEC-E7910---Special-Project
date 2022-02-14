%Steiner = importdata('Steiner_2_3_7.txt');   %7
%Steiner = importdata('Steiner_2_3_6.txt');   %6
%Steiner = importdata('Steiner_3_5_26.txt');  %260
Steiner = importdata('Steiner_3_5_65.txt'); %4368

tForSteinerSet = 3; % number of elements won't appear together in any block more than once(t) 
kForSteinerSet = 5; % number of element that subset will include
totNumOfSubsetInResult = 4368;
for c=1:1:totNumOfSubsetInResult %number of result in C --> how many subsets
    for t=c+1:1:totNumOfSubsetInResult %c+1 bec we need to compare it with the next subset until the end 
        steinerErrCnt = 0; % this count keeps the repeated numbers in the subsets
        for k=1:1:kForSteinerSet
            val = Steiner(c,k);
            for l=1:1:kForSteinerSet %to move to the next element of the subset
                if val == Steiner(t,l)
                    steinerErrCnt = steinerErrCnt + 1;
                end
                if(steinerErrCnt >= tForSteinerSet)
                    fprintf("There is an overlap between %d. subset and %d. subset\n",c, t);
                return
                end
            end
        end
    end
end
fprintf("This is a Steiner System");


