module traffic_lights_timer(
    input  logic       clk,
    input  logic       r,
    input  logic       start,
    output logic [3:0] counter,
    output logic       timerEND
);
    always_ff @(posedge clk or posedge r) begin
        if (r) begin
            counter  <= 4'd0;
            timerEND <= 1'b0;
        end
        else if (start) begin
            counter  <= 4'd5;
            timerEND <= 1'b0;
        end
        else if (counter > 4'd1) begin
            counter  <= counter - 4'd1;
            timerEND <= 1'b0;
        end
        else if (counter == 4'd1) begin
            counter  <= 4'd0;
            timerEND <= 1'b1; // Stays 1 once 0 is reached until a new start
        end
        else begin
            counter  <= 4'd0;
            timerEND <= 1'b1; // Retain timerEND = 1 so the FSM knows the minimum green time expired!
        end
    end
endmodule
