# PICAXE-RC-Throttle-Controller
Using a PICAXE 08M chip to control a DC motor from RC channel

The RC receiver I used is a Spektrum AR6600T.  The pulseIn command is used to read the throttle signal from the receiver presented at pin 4. The decoded pulse value is mapped to a range of 7 PWM duty cycles (from 0% to 100%).  The PWM output is then presented at pin 2 to driver a DC motor.  This process is setup in a loop so that it repeats itself indefinitely (or as long as your battery lasts).  A small delay (48 mSec) is added at the end of the process (ie between each iteration of the loop) to dampen the response a little, to give the motor time to react. 

An LED is added to pin 1.  The LED will blink when the circuit is in operation.  The blink frequency is increased in steps with the PWM duty cycle changes.  This is to give a visual clue of the operation in testing.  In actual use this can be satisfying to watch but not essential.

The logic to drive the LED is piggy-backed on the main loop, towards the end.  If a blinking LED is not required then one can safely remove these few lines of code.  It may result in a smoother or more responsive RC experience.  If you do so I appreciate you share the experience.

An alternative to the blinking LED is to turn on the LED only when PWM duty is above 0%.  Or, more simply, keep the LED stead on when the unit is powered.

The DC motor driver circuit uses one Darlington BJT transistor to drive a brused DC motor.  It also contains a voltage regulator IC to down-step the main battery from 7.2v to 5v to feed the PICAXE.  This is not the forum for RC and electronics so I won't go into details.  Suffice to say that this code is able to drive a much more powerful motor if you use MOSFET transistors for the motor driver.  The PWM control requirement is the same.

These are the things to adjust if the code is to be used on a different project:
1. The range of the RC throttle signal input.  I use the built-in debugger of the PICAXE Editor together with the development harness (an USB cable connected to a PICAXE project board) to monitor the value in the W1 variable register as I move the throttle up and down on the RC transmitter.  
2. Adjust the PWM period and duty cycle steps to your need.  The PWM Wizard in the PICAXE Editor is a great help.  But you need to experiment with your actual hardware to get the best results.
3. Adjust the time pause at the end of the loop.  Again this needs experimentation to get the best result.  The goal is to achieve smooth motor operations (no jitterings) and responsive control.

Enjoy your hobby, don't let the passion die :)
