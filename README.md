
# FPGA-Based Aircraft Landing Guidance System

A VHDL implementation of a real-time landing guidance and obstacle detection system
designed for FPGA.

---

## 📌 Project Overview

This system uses an ultrasonic sensor for rear distance measurement and IR sensors 
for side blind-spot detection. It classifies the surrounding environment into three 
zones and provides real-time alerts to guide safe landing/navigation.

| Zone    | Condition         | LED        | Buzzer | LCD        |
|---------|-------------------|------------|--------|------------|
| SAFE    | Distance > 50 cm  | Green ON   | OFF    | "SAFE"     |
| WARNING | Distance 16-50 cm | Yellow ON  | OFF    | "WARNING"  |
| DANGER  | Distance < 15 cm  | Red ON     | ON     | "DANGER"   |

---

## 🗂️ Repository Structure
