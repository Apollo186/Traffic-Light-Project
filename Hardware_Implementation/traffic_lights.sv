module traffic_lights(
    input  logic       clk,
    input  logic       r,
    input  logic       sensorNS,
    input  logic       sensorEW,
    output logic [2:0] states,
    output logic [0:6] disp_counter,
    output logic       clk_led
);
    logic [3:0] counter;
    logic       one_sec;
    logic       timer_start;
    logic       timerEND;

    clockdivider inst1(
        .clk(clk),
        .start_timer(1'b0),
        .slow_clock_signal(one_sec),
        .slow_led(clk_led)
    );

    timer_lights inst2(
        .clk(one_sec),
        .r(r),
        .start(timer_start),
        .counter(counter),
        .timerEND(timerEND)
    );

    fsm inst3(
        .clk(one_sec),
        .r(r),
        .sensorNS(sensorNS),
        .sensorEW(sensorEW),
        .timerEND(timerEND),
        .timer_start(timer_start),
        .states(states)
    );

    bcd inst4(
        .in(counter),
        .out(disp_counter)
    );
endmodule

// ============================================================================
// Timer Module
// ============================================================================
module timer_lights(
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

// ============================================================================
// FSM Module
// ============================================================================
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

module clockdivider(
	input    clk,start_timer,
	output wire slow_clock_signal,
	output reg slow_led
	);
	
	reg [25:0] cnt;
	wire slow_sig;
	assign slow_clock_signal = cnt[24];
	assign slow_sig = cnt[24];
	always @(posedge clk)
		if (start_timer == 1) begin
			cnt = 26'h0;
		end 
		else begin
			cnt = cnt + 1;
		end
	always @ (slow_sig)
		if (slow_sig == 1)
			slow_led = 1;
		else
			slow_led = 0;
endmodule

module bcd (
	input wire [3:0]in,
	output reg [0:6] out
	);
	
	always @(*) begin
		case(in)
			0: out = 7'b000_0001;
			1: out = 7'b100_1111;
			2: out = 7'b001_0010;
			3: out = 7'b000_0110;
			4: out = 7'b100_1100;
			5: out = 7'b010_0100;
			6: out = 7'b010_0000;
			7: out = 7'b000_1111;
			8: out = 7'b000_0000;
			9: out = 7'b000_0100;
			10: out = 7'b000_1000;
			11: out = 7'b110_0000;
			12: out = 7'b011_0001;
			13: out = 7'b100_0010;
			14: out = 7'b011_0000;
			15: out = 7'b011_1000;
			default: out = 7'b111_1111;
		endcase
	end


endmodule
