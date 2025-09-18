module QAMGenMod #(
    parameter M = 256, // qam order (powers of two)
    parameter W = 8, // output width
    parameter N = 1 // parallel symbols
)(
    input wire clk,
    input wire [$clog2(M) * N - 1:0] data_in,
    output reg signed [W*N-1:0] re_out,
    output reg signed [W*N-1:0] im_out,
    output reg valid 
);

    localparam axis_bits = $clog2(M)/2; // bits per axis e.g. 4 bits for 256-qam
    localparam levels = 1 << axis_bits; // levels per axis e.g. 16 for 256-qam

    integer i;
    integer re_idx, im_idx;
    always @(posedge clk) begin
        for(i = 0; i < N; i = i + 1) begin // for parallelism
            re_idx = data_in[$clog2(M)*i +: axis_bits]; // real index e.g. [0,1,2,3] for 16-qam
            im_idx = data_in[$clog2(M)*i + axis_bits +: axis_bits]; // imaginary index e.g. [0,1,2,3] for 16-qam

            re_out[W*i +: W] = (2*re_idx - levels + 1); // real output 
            im_out[W*i +: W] = -(2*im_idx - levels + 1); // imaginary output (flipped Q axis to match im_idx=0 to top)
        end
        valid <= 1'b1;
    end

endmodule