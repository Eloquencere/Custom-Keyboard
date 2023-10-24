class rand_key_gen;
    randc bit [3:0]rand_key;
    constraint valid_key {rand_key <= 8;}
endclass

class packet;
    bit [8:0] in_key; // 0 -> when a new instance is created
    bit [3:0] out_key;
    
    rand bit key_change;
    constraint change{key_change dist{0:=5, 1:=2};} // 0 -> no key change
    
    randc bit [3:0]rand_key, rand_range;
    rand bit [1:0]condition;
    constraint cycle_cases{condition dist{0:=5, [1:3]:/5};} // [1:3] has equal probability to that of 0
    constraint cases
    {
        if(condition == 0)
            rand_key <= 8; // fully valid
        else if(condition == 1)
            rand_key <= 5; // rand_no <=totalkeys-totalrows
        else if (condition == 2)
            rand_key%3 != 2; // rand_no%totalrows != totalrows-1
        else
            rand_range > 1; // 2 or more random number of 1s
    }
    
    rand_key_gen randomiser;
    function new();
        randomiser = new;
    endfunction
    
    function void post_randomize;
        case (condition)
            0: in_key = 'b1 << rand_key; // fully valid
            1: in_key = 'b1001 << rand_key;  // same column 
            2: in_key = 'b11 << rand_key;// same row
            3: repeat(rand_range)
                begin
                    assert(randomiser.randomize());
                    in_key |= (1 << randomiser.rand_key); // fully random
                end
        endcase
    endfunction
endclass