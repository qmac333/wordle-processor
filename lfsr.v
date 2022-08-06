module lfsr (
    input clock,
    input reset,
    output [3:0] rnd 
    );

wire feedback = random[3] ^ random[2]; 

reg [3:0] random, random_next, random_done;
reg [2:0] count, count_next; //to keep track of the shifts

always @ (posedge clock or posedge reset)
begin
 if (reset)
 begin
  random <= 4'hF; //An LFSR cannot have an all 0 state, thus reset to FF
  count <= 0;
 end
 
 else
 begin
  random <= random_next;
  count <= count_next;
 end
end

always @ (*)
begin
 random_next = random; //default state stays the same
 count_next = count;
  
  random_next = {random[3:0], feedback}; //shift left the xor'd every posedge clock
  count_next = count + 1;

 if (count == 4)
 begin
  count = 0;
  random_done = random; //assign the random number to output after 13 shifts
 end
 
end


assign rnd = random_done;

endmodule

module counterz(out, clock, reset);

    input clock, reset;
    output [31:0] out;

    wire [31:0] indata;
    wire cout;

    full_cla adder(.sum(indata), .carryout(cout), .data_operandA(out), .data_operandB(32'b00000000000000000000000000000000), 
                   .carryin(1'b1), .p(out), .g(32'b00000000000000000000000000000000));

    register count(.clr(reset), .out(out), .clk(clock), .ie(1'b1), .indata(indata));

endmodule
