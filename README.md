# Traffic-Light-Project
This digital design project lets you simulate a traffic light controller. When a sensor is switched on, it transitions to yellow and stays yellow for 5 seconds before transitioning to red. Exiting the red state triggers another 5-second timer in the green state, and once the timer hits 0, the cars in the green lanes can go.

## Testbench Simulation
<img width="1305" height="191" alt="Screenshot 2026-09-15 at 9 29 42 PM" src="https://github.com/user-attachments/assets/f3fc58e6-c9e4-4852-a7cc-f2539ae484c6"/>

## Pin Assignment
* SW0 - Sensor North/South
* SW1 - Sensor East/West
* SW2 - Reset
* LED0 - States[0]
* LED1 - States[1]
* LED2 - States[2]
* LED9 - Clock Led

## FSM States
* 0 - 000 - All Red
* 1 - 001 - Green North/South
* 2 - 010 - Yellow North/South
* 3 - 011 - Red North/South
* 4 - 100 - Green East/West
* 5 - 101 - Yellow East/West
* 6 - 110 - Red East/West
* 7 - 111 - Dont Care

## FPGA Implementation

### All Red
<img width="729" height="497" alt="Screenshot 2026-09-15 at 11 42 24 PM" src="https://github.com/user-attachments/assets/10f58f53-be4c-4d76-9f6b-03ffedd93b3d" />

### Green North/South
<img width="1266" height="585" alt="IMG_2730" src="https://github.com/user-attachments/assets/ea64157e-42bb-4dc4-9dac-75bbd770ccfa" />


### Yellow North/South
<img width="1266" height="585" alt="IMG_2731" src="https://github.com/user-attachments/assets/f07a50bc-dc70-405a-8538-a2860e614ed5" />

### Red North/South
<img width="1266" height="585" alt="IMG_2732" src="https://github.com/user-attachments/assets/d2603b0b-0d5e-40d2-847a-e8f8137c15be" />

### Green East/West
<img width="631" height="468" alt="Screenshot 2026-09-15 at 11 42 40 PM" src="https://github.com/user-attachments/assets/8b3eb27b-ce73-4bcd-9ca8-3154e418b899" />


