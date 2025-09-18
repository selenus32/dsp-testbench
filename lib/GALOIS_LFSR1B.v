// RNG
// 8-bit maximal-period galois lfsr
// 2^8 - 1 possible states (state cannot be all zero)
// XOR follows GF(2) addition
// shift plus feedback follows multiplication by x in GF(2^n) mod the primitive polynomial
// 
// ref: https://en.wikipedia.org/wiki/Linear-feedback_shift_register
// Author: selenus32

module GALOIS_LFSR1B #(
    parameter start_state = 8'hE1
)(
    input clk,
    input rst,
    output reg [7:0] LFSR
);
    wire msb = LFSR[7];
    always @(posedge clk) begin // left-shifting
        if(rst) begin
            LFSR <= start_state;
        end else begin 
            LFSR <= { // x^8 + x^6 + x^5 + x^4 + 1 primitive
                LFSR[6],
                LFSR[5] ^ msb,
                LFSR[4] ^ msb,
                LFSR[3] ^ msb,
                LFSR[2],
                LFSR[1],
                LFSR[0],
                msb
            };
        end
    end

endmodule
