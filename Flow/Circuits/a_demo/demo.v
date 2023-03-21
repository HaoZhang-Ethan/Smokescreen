module perceptron(input [7:0] inputs, output reg output);

  // Define weights and bias
  reg [7:0] weights [0:3];
  reg [7:0] bias;

  // Define threshold
  parameter THRESHOLD = 4'b1000;

  // Define activation function
  function reg activate;
    input reg [7:0] value;
    begin
      if (value >= THRESHOLD) begin
        activate = 1;
      end
      else begin
        activate = 0;
      end
    end
  endfunction

  // Define perceptron unit
  function reg [7:0] perceptron_unit;
    input [7:0] inputs;
    input [7:0] weights;
    input [7:0] bias;
    begin
      reg [7:0] sum = 0;
      for (int i = 0; i < 8; i = i + 1) begin
        sum = sum + (inputs[i] * weights[i]);
      end
      perceptron_unit = activate(sum + bias);
    end
  endfunction

  // Define output as combination of perceptron units
  always @(*) begin
    output = perceptron_unit(inputs, weights[0], bias) & 
             perceptron_unit(inputs, weights[1], bias) & 
             perceptron_unit(inputs, weights[2], bias) & 
             perceptron_unit(inputs, weights[3], bias);
  end

endmodule
