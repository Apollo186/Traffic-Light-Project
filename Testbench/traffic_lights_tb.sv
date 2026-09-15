`timescale 1s/1ms
module tb;
    logic  clk;
    logic  r;
    logic  sensorNS;
    logic  sensorEW;
    logic [2:0] states;
    logic [3:0] counter;
    logic   timer_start;
    logic   timerEND;

    
    traffic_lights_timer uut(
        .clk(clk),
        .r(r),
        .start(timer_start),
        .counter(counter),
        .timerEND(timerEND)
    );

    fsm uut2(
        .clk(clk),
        .r(r),
        .sensorNS(sensorNS),
        .sensorEW(sensorEW),
        .timerEND(timerEND),
        .timer_start(timer_start),
        .states(states)
    );

    always #0.5 clk = ~clk;

    initial begin
        $dumpfile("traffic.vcd");
        $dumpvars(0,tb);

        clk = 0;
        r = 1;
        sensorNS = 0;
        sensorEW = 0;

        @(posedge clk);
        #0.1;
        r = 0;

        @(posedge clk);
            sensorNS = 1;
        repeat(10) @(posedge clk);

        @(posedge clk);
            sensorNS = 0;
            sensorEW = 1;
        repeat(10) @(posedge clk);

        @(posedge clk);
            sensorEW = 0;
            sensorNS = 1;
        repeat(20) @(posedge clk);

        $finish;

    end

    
endmodule
