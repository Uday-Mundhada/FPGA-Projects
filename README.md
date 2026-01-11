# FPGA-Based Digital Design Projects (Verilog HDL)

This repository contains FPGA projects implemented using **Verilog HDL** and tested on the **Intel/Altera Cyclone II DE1 FPGA board (EP2C20F484C7)**.  
The projects focus on fundamental digital design concepts such as **finite state machines, counters, clock division, modular arithmetic, and 7-segment display interfacing**, with direct hardware validation.

The designs were implemented and verified directly on hardware without relying on simulation, using LEDs, switches, push buttons, and 7-segment displays for observation and debugging.

---

## 📌 Projects Included

### 1. Sequence Detector (1011) using FSM
### 2. FPGA 7-Segment Display Custom Counter

---

## 🧠 Project 1: Sequence Detector (1011)

### 📖 Description
This project implements a **Mealy-type Finite State Machine (FSM)** that detects the binary sequence **1011**.  
User inputs are provided through push buttons on the FPGA board, and the detection result is indicated using an LED.  
The current FSM state and input value are displayed on the onboard 7-segment displays for better understanding and debugging.

---

### 🔧 Key Features
- Mealy FSM with 5 states
- Push-button based binary input (`1` and `0`)
- Button synchronization and edge detection
- Sequence detection output latched for 1 second using a counter
- Real-time FSM state and input display on 7-segment displays
- Fully implemented and tested on hardware

---

### 🛠 Inputs and Outputs

**Inputs**
- `clk` : 50 MHz onboard clock
- `rst_n` : Active-low reset
- `btn_one` : Button input for binary `1`
- `btn_zero` : Button input for binary `0`

**Outputs**
- `Y` : LED output indicating sequence detection
- `HEX0–HEX3` : 7-segment displays showing FSM state and input

---

### 🔁 FSM States

| State | Description |
|------|------------|
| s0 | No bits matched |
| s1 | Detected `1` |
| s2 | Detected `10` |
| s3 | Detected `101` |
| s4 | Detected `1011` (sequence detected) |

---

### 🧩 Files
- `Seq_Detector_1011.v` – Top module implementing FSM and hardware logic
- `seg7_lut.v` – 7-segment display lookup table

---

## 🔢 Project 2: FPGA 7-Segment Display Custom Counter

### 📖 Description
This project demonstrates a **digitally configurable 4-digit counter (0000–9999)** implemented on an FPGA.  
The counter supports **runtime speed control and modulo selection** using onboard switches and displays the count on **four 7-segment displays**.

---

### 🎚 Functional Features
- Adjustable counting speed using switches
- Selectable modulo range (0–99, 0–999, 0–1999, 0–9999)
- Binary to BCD conversion using Double Dabble algorithm
- Common-anode 7-segment display interfacing
- LED indicators showing active configuration
- Direct hardware testing on FPGA board

---

### ⚙️ Speed Control (SW[3:2])

| Switch Setting | Frequency |
|--------------|----------|
| `00` | 100 Hz (Fast) |
| `01` | 20 Hz (Medium) |
| `10` | 10 Hz (Slow) |
| `11` | 2 Hz (Very Slow) |

---

### 🔢 Modulo Control (SW[5:4])

| Switch Setting | Counting Range |
|--------------|---------------|
| `00` | 0 – 9999 |
| `01` | 0 – 99 |
| `10` | 0 – 999 |
| `11` | 0 – 1999 |

---

### 🧩 Design Architecture

50 MHz Clock
↓
Clock Divider (Speed Control)
↓
Modulo Counter
↓
Binary to BCD Converter
↓
7-Segment Decoders


---

### 🧩 Files
- `counter_7seg_top.v` – Top-level module
- `clock_divider.v` – Programmable clock divider
- `mod_counter.v` – Modulo counter logic
- `bin_to_bcd.v` – Binary to BCD conversion
- `sevenseg_decoder.v` – 7-segment decoder
- `de1_pin_assignments.qsf` – Pin assignment file for DE1 board

---

## 🧪 Testing Methodology

- Designs were tested **directly on FPGA hardware**
- LEDs and 7-segment displays were used for observing internal behavior
- Push buttons and switches were used as real-time inputs
- No simulation tools were used during development

---

## 🧰 Tools and Technologies

- **FPGA Board:** Intel/Altera Cyclone II DE1
- **HDL:** Verilog
- **Software:** Intel Quartus Prime
- **Display:** 4-digit common-anode 7-segment display

---

## 🎓 Learning Outcomes

Through these projects, the following concepts were learned:
- FSM design using Verilog
- Button synchronization and edge detection
- Clock division and timing awareness
- Modular counter design
- Binary to BCD conversion
- FPGA hardware debugging using LEDs and displays
- Practical FPGA pin assignment and implementation flow

---

## 🚀 Applications

- Digital counters and timers
- Sequence detection systems
- Educational FPGA demonstrations
- Scoreboards and display controllers
- Introductory FPGA and VLSI learning projects

---

## 📌 Notes

These projects are intended for **learning and academic purposes** and represent beginner-to-intermediate level FPGA design concepts implemented with real hardware testing.

---

## 👤 Author

**Uday Mundhada**  
B.Tech – Electronics and Communication Engineering  
G H Patel College of Engineering and Technology  

---

## 📄 License

This project is open for educational use. Feel free to explore, modify, and learn from it.
