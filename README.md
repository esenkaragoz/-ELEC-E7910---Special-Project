# -ELEC-E7910---Special-Project
This branch includes scripts to simulate 2-IC / 3-IC Steiner and Random code for multiframe. All of them has 3 frame and 26*3 slots, number of users is 60.
Aprroach is getting time offset randomly by using randi function in matlab. Timeoffset can be the slot number which user starts to be active.
Then adding this timeoffset to each user codewords to calculate final slot numbers which users send their data accordingly.
