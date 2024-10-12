`timescale 1ns / 1ps

module iotestbench();
logic CLK100MHZ, BTNC, BTNL, BTNR;
logic [15:0] SW;
logic [7:0] AN;
logic [6:0] A2G;

initial
begin
    #0;
    CLK100MHZ = 0;
    BTNC = 1;
    #2;
    BTNC = 0;
    #2;
    BTNL = 1;
    BTNR = 1;
    #2;
    SW = 16'b00000010_00001000;
end

always
    begin
        #5;
        CLK100MHZ = ~CLK100MHZ;
    end

top_module tm
(
CLK100MHZ, BTNC, BTNL, BTNR, SW, AN, A2G
);

endmodule
