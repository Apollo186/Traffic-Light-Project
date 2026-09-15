module fsm(
    input  logic       clk,
    input  logic       r,
    input  logic       sensorNS,
    input  logic       sensorEW,
    input  logic       timerEND,
    output logic       timer_start,
    output logic [2:0] states
);
    typedef enum logic [2:0] {
        ALL_RED   = 3'd0,
        GREEN_NS  = 3'd1,
        YELLOW_NS = 3'd2,
        RED_NS    = 3'd3,
        GREEN_EW  = 3'd4,
        YELLOW_EW = 3'd5,
        RED_EW    = 3'd6
    } statetype;

    statetype currentstate, nextstate;

    // State Register
    always_ff @(posedge clk or posedge r) begin
        if (r) begin
            currentstate <= ALL_RED;
        end
        else begin
            currentstate <= nextstate;
        end
    end

    // Next-State and Output Combinational Logic
    always_comb begin
        // Default assignments to eliminate latches
        nextstate   = currentstate;
        timer_start = 1'b0;
        states      = currentstate;

        case (currentstate)
            ALL_RED: begin
					
					
                if (sensorNS) begin
                    nextstate   = GREEN_NS;
						  timer_start = 1'b1;
                    
                end
                else if (sensorEW) begin
                    nextstate   = GREEN_EW;
                    timer_start = 1'b1;
                end
					 
            end

            GREEN_NS: begin
                // Transition to yellow after 5 seconds if side traffic is waiting
                if (sensorEW && timerEND) begin
                    nextstate   = YELLOW_NS;
                    timer_start = 1'b1;
                end
            end

            YELLOW_NS: begin
                // Yellow holds for timer duration, then transitions to Red
                if (timerEND) begin
                    nextstate   = RED_NS;
                end
            end

            RED_NS: begin
                // Safe clearance delay before switching traffic to East-West
                nextstate   = GREEN_EW;
                timer_start = 1'b1;
            end

            GREEN_EW: begin
                // Transition to yellow after 5 seconds if side traffic is waiting
                if (sensorNS && timerEND) begin
                    nextstate   = YELLOW_EW;
                    timer_start = 1'b1;
                end
            end

            YELLOW_EW: begin
                // Yellow holds for timer duration, then transitions to Red
                if (timerEND) begin
                    nextstate   = RED_EW;
                end
            end

            RED_EW: begin
                // Safe clearance delay before switching traffic back to North-South
                nextstate   = GREEN_NS;
                timer_start = 1'b1;
            end

            default: begin
                nextstate   = ALL_RED;
                timer_start = 1'b0;
            end
        endcase
    end
endmodule


