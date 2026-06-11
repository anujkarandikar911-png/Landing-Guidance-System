# FPGA-Based Aircraft Landing Guidance System

A VHDL implementation of a real-time landing guidance and obstacle detection system
designed for FPGA.

---

##  Project Overview

This system uses an ultrasonic sensor for rear distance measurement and IR sensors 
for side blind-spot detection. It classifies the surrounding environment into three 
zones and provides real-time alerts to guide safe landing/navigation.

| Zone    | Condition         | LED        | Buzzer | LCD        |
|---------|-------------------|------------|--------|------------|
| SAFE    | Distance > 50 cm  | Green ON   | OFF    | "SAFE"     |
| WARNING | Distance 16-50 cm | Yellow ON  | OFF    | "WARNING"  |
| DANGER  | Distance < 15 cm  | Red ON     | ON     | "DANGER"   |

---

---

## ⚙️ System Architecture

### Modules

- **clock_divider** — Takes 100 MHz input clock and generates enable pulses at
  1 MHz, 1 kHz, 5 Hz and 100 Hz for use by other modules
- **debounce** — Filters mechanical button noise using a 4-bit shift register
  sampled at 1 kHz
- **ultrasonic_controller** — Controls the HC-SR04 sensor through states:
  IDLE → TRIGGER → WAIT_ECHO → MEASURE → DONE, outputs distance in cm
- **zone_classifier** — Maps distance to zone: DANGER (≤15 cm),
  WARNING (16–50 cm), SAFE (>50 cm)
- **decision_fsm** — Combines ultrasonic zone and IR sensor inputs with driver
  intent buttons to output a final danger flag and status message
- **top_module** — Instantiates all modules, generates 4 kHz buzzer tone,
  and routes LED/buzzer outputs

---

## 🔌 Inputs & Outputs

| Port       | Direction | Description                         |
|------------|-----------|-------------------------------------|
| clk        | in        | 100 MHz system clock                |
| rst_btn    | in        | Active-high reset                   |
| echo_rear  | in        | Echo signal from ultrasonic sensor  |
| ir_L       | in        | Left IR sensor input                |
| ir_R       | in        | Right IR sensor input               |
| btn_L      | in        | Left turn intent button             |
| btn_R      | in        | Right turn intent button            |
| trig_rear  | out       | Trigger signal to ultrasonic sensor |
| led_safe   | out       | Green LED                           |
| led_warn   | out       | Yellow LED                          |
| led_danger | out       | Red LED                             |
| buzzer     | out       | 4 kHz audio alert                   |
| lcd_rs     | out       | LCD register select                 |
| lcd_e      | out       | LCD enable                          |
| lcd_data   | out       | LCD 8-bit data bus                  |

---

## 🛠️ Tools & Technology

- **Language:** VHDL
- **Target:** FPGA (100 MHz clock)
- **Sensor:** HC-SR04 Ultrasonic + IR sensors
- **Tools:** Xilinx Vivado / Intel Quartus
