module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] expected;
  integer i, j, k;
  integer errors = 0;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    for (k = 0; k < 2; k = k + 1) begin
      for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
          t_op = k[0];
          t_a  = i;
          t_b  = j;
          #10;

          expected = (k == 0) ? (i + j) : (i - j);

          if (t_result !== expected) begin
            $display("MISMATCH t=%0t: op=%b a=%0d b=%0d | result=%0d expected=%0d",
                      $time, t_op, t_a, t_b, t_result, expected);
            errors = errors + 1;
          end
        end
      end
    end

    if (errors == 0)
      $display("ALL TESTS PASSED");
    else
      $display("%0d MISMATCH(ES) FOUND", errors);

    $finish;
  end

endmodule