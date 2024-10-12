module mux7seg
(
input logic clk, reset,
input logic [31:0] digits,
output logic [6:0] a2g,
output logic [7:0] AN
);
logic [19:0] clkdiv;
logic [2:0] s;
logic [3:0] digit;

assign s = clkdiv[19:17];
    
always_ff @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        clkdiv <= 0;
    end
    else
        clkdiv <= clkdiv + 1;
end
    
always_comb
    case(s)
        3'b000: digit = digits[31:28];
        3'b001: digit = digits[27:24];
        3'b010: digit = digits[23:20];
        3'b011: digit = digits[19:16];
        3'b100: digit = digits[15:12];
        3'b101: digit = digits[11:8];
        3'b110: digit = digits[7:4];
        3'b111: digit = digits[3:0];
        default: digit = 4'b0000;
    endcase
always_comb
    case(s)
        3'b000: AN = 8'b01111111;
        3'b001: AN = 8'b10111111;
        3'b010: AN = 8'b11011111;
        3'b011: AN = 8'b11101111;
        3'b100: AN = 8'b11110111;
        3'b101: AN = 8'b11111011;
        3'b110: AN = 8'b11111101;
        3'b111: AN = 8'b11111110;       
    endcase        
    
always_comb
begin
    case(digit)
        4'b0000: a2g = ((s == 4) ? 7'b1110110 : 7'b0000001);
        4'b0001: a2g = 7'b1001111;
        4'b0010: a2g = 7'b0010010;
        4'b0011: a2g = 7'b0000110;
        4'b0100: a2g = 7'b1001100;
        4'b0101: a2g = 7'b0100100;
        4'b0110: a2g = 7'b0100000;
        4'b0111: a2g = 7'b0001111;
        4'b1000: a2g = 7'b0000000;
        4'b1001: a2g = 7'b0000100;
        4'b1010: a2g = 7'b0001000;
        4'b1011: a2g = 7'b1100000;
        4'b1100: a2g = 7'b0110001;
        4'b1101: a2g = 7'b1000010;
        4'b1110: a2g = 7'b0110000;
        4'b1111: a2g = 7'b0111000;
    endcase
end
 
endmodule