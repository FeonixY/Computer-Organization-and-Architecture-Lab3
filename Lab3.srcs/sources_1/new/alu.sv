module alu
(
input logic [31:0] in1, in2,
input logic [2:0] alucontrol,
output logic [31:0] out,
output logic zero
);

always_comb
begin
    case (alucontrol)
        3'b010: out = in1 + in2;
        3'b110: out = in1 - in2;
        3'b000: out = in1 & in2;
        3'b001: out = in1 | in2;
        3'b111: out = in1 < in2 ? 1 : 0;
        default: out = 0;
    endcase
end

assign zero = (out == 0);

endmodule

