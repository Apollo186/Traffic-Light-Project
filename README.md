# Traffic-Light-Project

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
