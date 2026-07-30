# Football Scoreboard on FPGA

A structural Verilog scoreboard built for the Terasic DE1-SoC. The design
tracks two teams, enforces the touchdown/conversion sequence, manages
possession, and drives active-low seven-segment displays for both scores and a
selectable game/play clock.

The original course build was synthesized and run on DE1-SoC hardware. This
repository contains the cleaned HDL, self-checking simulations, and a Quartus
project retargeted to the cleaned top level with the pin assignments recovered
from that build. It does not contain hardware photographs.

## Behavior

- Touchdown: 6 points and opens a conversion state
- Extra point: 1 point, accepted only after a touchdown
- Two-point conversion: 2 points, accepted only after a touchdown
- Field goal: 3 points and changes possession
- Safety: 2 points and changes possession
- Manual possession toggle
- Ten-minute game clock
- Fifteen-second play clock that resets when possession changes
- Two seven-segment digits per team and two selectable clock digits

## Architecture

| Module | Responsibility |
| --- | --- |
| `football_scoreboard_top.v` | Connects scoring, timing, and display modules |
| `scoring_mechanism_DFF.v` | Score, possession, and conversion-state logic |
| `my_dff.v` | Reusable D flip-flop used by the score registers |
| `edge_detector.v` | Converts held scoring inputs into one event |
| `timer_module.v` | Produces a one-cycle 1 Hz enable from the 50 MHz board clock |
| `countdown_timer.v` | Stores and formats the game and play clocks |
| `hex_decoder.v` | Converts BCD values to active-low seven-segment outputs |

The top-level module is parameterized so the clock divider can run quickly in
simulation while retaining the 50 MHz board default for synthesis.

`FootballScoreboardProject.qpf` and `FootballScoreboardProject.qsf` target the
DE1-SoC's Cyclone V device and map the current top-level ports to the pins used
by the original course build. The retargeted project was not recompiled in
Quartus during this repository cleanup, so run a full Analysis & Synthesis pass
before treating the updated project files as a new hardware validation.

## Verify

Install Icarus Verilog, then run:

```bash
make test
```

The testbenches check:

- conversion attempts are ignored unless a touchdown opened the conversion
  state;
- scoring updates the correct team and possession changes at the intended
  events;
- the game and play clocks count down, stop at zero, and reset the play clock
  on a possession change;
- decimal digits map to the expected seven-segment patterns.

The same command runs automatically in GitHub Actions.

## Target the DE1-SoC

1. Open `FootballScoreboardProject.qpf` in Quartus.
2. Confirm that `football_scoreboard_top` is the top-level entity.
3. Run Analysis & Synthesis and review every pin assignment.
4. Compile and program the board.

Scoring inputs are active high. The edge detector prevents a held input from
being counted repeatedly, but it is not a complete mechanical debounce filter.
Use debounced board inputs when necessary.
