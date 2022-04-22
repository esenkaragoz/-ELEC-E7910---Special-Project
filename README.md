# -ELEC-E7910---Special-Project
This branch includes scripts to simulate 2-IC / 3-IC Steiner and Random code for multiframe.
All of them has 2 frame and 26*2 slots, number of users is 43.
The previous approach that we applied in multiFrameSimulations branch gives unexpected results such that 3-IC Steiner System performance is much worse in 3 frame comparing the 1 frame. It is because of the nature of Steiner system which has some delicate mathematical structures in each codeword. In this branch we changed our approach as follows:

The codewords of two users are c_1 = [1 3 12 15 18] and c_2 = [3 5 14 17 20]

If c_1 starts at slot 5, then it is not able to send first two slot which is less than 5 but it will send the rest 3 slots. The first two slots that we omitted will be shifted in the next slot, so they will be sent at 27(1+26) and 29(3+26). slots. 

Same rule applies for the next user which wont be able to send first 2 slots in 1.st frame and will postpone them to the next frame.
The transmission of one codeword may then extend to two frames, and this is done in a cyclic manner. 
