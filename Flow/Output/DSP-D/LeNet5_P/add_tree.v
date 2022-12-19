/*======================================================
Descripton:
parameterized adder tree, full comb

Create:  
Yipeng   wangyipengv@outlook.com  20191126

Modify:

Notes:
1. contain constant functions
=========================================================*/
module adder_tree#(
    parameter IN_WIDTH = 8,
    parameter NUM   = 16,
    parameter OUT_WIDTH = 32
)(
    input  logic [NUM * IN_WIDTH - 1 : 0] a,
    output logic signed [OUT_WIDTH - 1 : 0] ans
);
genvar i, j;
// - gen adders ----------------------------------------------------------
generate
for(i = 1; i <= gen_level(NUM); i++)begin:gen_add_levels
    logic signed [IN_WIDTH + i - 1 : 0] sum[gen_num_of_a_level(NUM,i)]; // more bit for every level
    if(i == 1) begin    // - special for first level -------------------
    
        for(j = 1; j <= gen_num_of_a_level(NUM,i) - 1; j++)begin: gen_add_levels
            assign sum[j] = a[(NUM- 2*j + 2) * IN_WIDTH - 1 -: IN_WIDTH] + a[(NUM- 2*j + 1) * IN_WIDTH - 1 -: IN_WIDTH];
        end
        if(gen_odd_sign(NUM,i) == 1) 
            assign sum[gen_num_of_a_level(NUM,i)] = a[IN_WIDTH - 1 : 0]; //need auto sign extention
        else
            assign sum[gen_num_of_a_level(NUM,i)] = a[IN_WIDTH - 1 : 0] + a[2*IN_WIDTH - 1 : IN_WIDTH];

    end else if (i == gen_level(NUM)) begin    // - output for last level ------------------

        assign ans = gen_add_levels[i-1].sum[1] + gen_add_levels[i-1].sum[2];          //need auto sign extention

    end else begin      // - intermediate levels ------------------

        for(j = 1; j <= gen_num_of_a_level(NUM,i) - 1; j++)begin: gen_add_levels
            assign sum[j] = gen_add_levels[i-1].sum[(NUM- 2*j + 2) * IN_WIDTH - 1 -: IN_WIDTH] + gen_add_levels[i-1].sum[(NUM- 2*j + 1) * IN_WIDTH - 1 -: IN_WIDTH];
        end
        if(gen_odd_sign(NUM,i) == 1) 
            assign sum[gen_num_of_a_level(NUM,i)] = gen_add_levels[i-1].sum[IN_WIDTH - 1 : 0];       //need auto sign extention
        else
            assign sum[gen_num_of_a_level(NUM,i)] = gen_add_levels[i-1].sum[IN_WIDTH - 1 : 0] + gen_add_levels[i-1].sum[2*IN_WIDTH - 1 : IN_WIDTH];

    end
end
endgenerate

// - functions ----------------------------------
function integer gen_level;
input integer num;
begin
    gen_level = 0;
    while (num > 1) begin
        num = $clog2(num);
        gen_level++;
    end
end  
endfunction

function  integer  gen_odd_sign;
input integer num;
input integer i;
begin
    while(i > 1) begin
        num = $clog2(num);
        i--;
    end
    gen_odd_sign = (num % 2) == 1;
end  
endfunction

function integer  gen_num_of_a_level;
input integer num;
input integer i;
begin
    while(i > 1) begin
        num = $clog2(num);
        i--;
    end
    gen_num_of_a_level = $clog2(num);
end  
endfunction

endmodule

