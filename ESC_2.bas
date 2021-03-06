'RC motor speed controller (ESC) No Reverse
'
symbol rcThrPin = C.4 ; RC receiver channel input
symbol pwmOutPin = C.2 ; PWM output
symbol ledOutPin = C.1 ; LED output
symbol pwmPeriod = 207 ; 4800Hz @ 4MHz 
symbol pwmDutyMin = 0
symbol pwmDuty50 = 415 ; 50% duty, motor not responsive lower than 50%
symbol pwmDuty60 = 498 ; 60% duty
symbol pwmDuty70 = 581 ; 70% duty
symbol pwmDuty80 = 664 ; 80% duty
symbol pwmDuty90 = 747 ; 90% duty
symbol pwmDutyMax = 831 ; 100% duty
symbol rcPulseMin = 110 ; RC throttle min value
symbol rcIdleThreshold = 130 ; RC throttle value at motor idle 
symbol rcPulseMax = 190
symbol rcStepRatio =  b12 ; convert from RC increments above idle to PWM duty cycle
symbol ledSkipRatio = w1
symbol pwmVar = w4 ; pwmout duty cycle
symbol pwmLast = w2 ; last PWM duty value
symbol ledSkip = w0 ; LED blinker (OFF cycles)
symbol ledOnCycles = b6 ; Number of ON cycles for each LED blink
symbol cyclePause = b7 ; Pause after each read/pwmout cycle
symbol ledCycleCount = b10 ;
symbol rcPulseIn = b11
symbol ledStatus = b13
output pwmOutPin
output ledOutPin
input rcThrPin
'Initialise clock and LED
'SETFREQ m4	; set 4MHz operation (default)
let cyclePause = 48 ; msec
let ledOnCycles = 100 / cyclePause ; msec / cyclePause
let ledCycleCount = 0
let ledSkip = 1000 / cyclePause
low ledOutPin
let ledStatus = 0 ; LED is off
let rcStepRatio = rcPulseMax - rcIdleThreshold
let rcStepRatio = pwmDutyMax - pwmDuty50 / rcStepRatio + 1
let ledSkipRatio = pwmDutyMax - pwmDuty50
let ledSkipRatio = 1000 - 100 / ledSkipRatio
'PWM output begin
let pwmVar = pwmDutyMin
pwmout pwmOutPin, pwmPeriod, pwmVar 
'Main loop
Do  
	pulsin rcThrPin, 1, rcPulseIn ; read throttle pulse width
	let pwmLast = pwmVar
	select case rcPulseIn
		case < rcIdleThreshold
			let pwmVar = pwmDutyMin
			let ledSkip = 972 / cyclePause
;		case >= rcPulseMax
;			let pwmVar = pwmDutyMax
;			let ledSkip = 84 / cyclePause
        else
            let pwmVar = rcPulseIn - rcIdleThreshold * rcStepRatio + pwmDuty50
            if pwmVar < 0 or pwmVar > pwmDutyMax then
			    let pwmVar = pwmLast
            endif
            let ledSkip = pwmDutyMax - pwmVar * ledSkipRatio / cyclePause + 1
	endselect
	'debug
	if pwmVar != pwmLast then
		pwmout pwmOutPin, pwmPeriod, pwmVar ; may use pwmDuty in newer PICAXE models
	endif
	let ledCycleCount = ledCycleCount + 1
	if ledStatus = 1 then ; LED is on
		if ledCycleCount >= ledOnCycles then
			low ledOutPin
			let ledCycleCount = 0
			let ledStatus = 0
		endif
	else ; LED is off
		if ledCycleCount >= ledSkip then
			high ledOutPin
			let ledCycleCount = 0
			let ledStatus = 1
		endif
	endif
	pause cyclePause
Loop
'Program End

 