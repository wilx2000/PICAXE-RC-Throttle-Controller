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
symbol pwmVar = w4 ; pwmout duty cycle
symbol pwmLast = w2 ; last PWM duty value
symbol ledSkip = w6 ; LED blinker (OFF cycles)
symbol ledOnCycles = b6 ; Number of ON cycles for each LED blink
symbol cyclePause = b7 ; Pause after each read/pwmout cycle
symbol ledCycleCount = w5 ;
symbol ledStatus = b1
output pwmOutPin
output ledOutPin
input rcThrPin
'Initialise clock and LED
'SETFREQ m4	; set 4MHz operation (default)
let cyclePause = 48
let ledOnCycles = 84 / cyclePause 
let ledCycleCount = 0
let ledSkip = 872 / cyclePause
low ledOutPin
let ledStatus = 0 ; LED is off
'PWM output begin
let pwmVar = pwmDutyMin
pwmout pwmOutPin, pwmPeriod, pwmVar 
'Main loop
Do  
	pulsin rcThrPin, 1, w1 ; read throttle pulse width
	let pwmLast = pwmVar
	select case w1
		case < 130
			let pwmVar = pwmDutyMin
			let ledSkip = 972 / cyclePause
		case < 140
			let pwmVar = pwmDuty50
			let ledSkip = 824 / cyclePause
		case < 150
			let pwmVar = pwmDuty60
			let ledSkip = 676 / cyclePause
		case < 160
			let pwmVar = pwmDuty70
			let ledSkip = 528 / cyclePause
		case < 170
			let pwmVar = pwmDuty80
			let ledSkip = 380 / cyclePause
		case < 180
			let pwmVar = pwmDuty90
			let ledSkip = 232 / cyclePause
		case >= 180
			let pwmVar = pwmDutyMax
			let ledSkip = 84 / cyclePause
		else
			let pwmVar = pwmLast
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