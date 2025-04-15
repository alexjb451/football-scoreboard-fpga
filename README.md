Football Scoreboard - Verilog FPGA Project
This project implements a digital football scoreboard using Verilog and an FPGA (DE1-SoC). It supports:

Touchdowns, Field Goals, Safeties, Extra Points, and Two-Point Conversions

Two-team scoring logic with possession-based control

Game clock with dual modes: a 10-minute quarter timer and a 15-second play clock

View toggle switch to switch between timers

Automatic clock reset on possession change

Seven-segment display output for scores and game time

Project Structure
scoringMechanism.v: Handles scoring inputs, tracks team scores, and manages ball possession.

game_clock_DFF.v: Implements the dual-mode timer with clock counting and reset logic based on possession and toggle.

sevenSegDecoder.v: Converts 4-bit binary numbers to seven-segment display format.

How It Works
User can simulate scoring events (TD, FG, etc.) via input switches/buttons.

A switch toggles the main game clock view (between 10:00 and 0:15 modes).

On a scoring event that switches possession (e.g. extra point), the play clock resets.

Output is shown on the 7-segment displays.

How to Run
Open project in Quartus Prime.

Compile all .v modules.

Upload to DE1-SoC board.

Use physical inputs to simulate game events.
