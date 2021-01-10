# maglev-control

<p align="center">
  <img width="500" src="https://github.com/tensarflow/maglev-control/blob/main/maglev.png">
</p>
1. Load the .ino file on the NodeMCUv3 and run it. 
2. Connect the PC to the WiFi Access Point "ESPsoftAP_01" of the NodeMCU with the password "pass-to-soft-AP".
3. Run the .pde file.

To tune the PID Parameters you can use the serial monitor of Arduino IDE:

- P: Increase P-Gain
- p: Decrease P-Gain
- I: Increase I-Gain
- i: Decrease I-Gain
- D: Increase D-Gain
- d: Decrease D-Gain

Setting new PID parameters through the interface is currently causing the a delay in the control loop, which is long enough to let the magnet fall down. (TODO)

## Set up the electronics:

<p align="center">
  <img width="500" src="https://github.com/tensarflow/maglev-control/blob/main/maglev_electronics.png">
</p>
