@echo off & setlocal enabledelayedexpansion
cd "%~dp0"
REM == \e definition ==
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"

REM == Sets the background/foreground color to white/black and clears ==
echo(%\e%[H%\e%[48;2;255;255;255m%\e%[38;2;0;0;0m%\e%[2J%\e%[?25l

REM == Sets the display dimensions to 64 columns and 32 lines
mode 64,32
set /a "this.modeW=64, this.modeH=32"

REM == Sets the font to Raster 8x8 and disables resizing ==
set /a "rasterX=8, rasterY=8, noResize=1"

REM == Injects getInput64.dll and checks for errors ==
if not exist getInput64.dll (
	echo File not found: getInput64.dll
	pause
	exit /b 1
)
rundll32.exe getInput64.dll,inject
if not defined getInputInitialized (
	echo GetInput failed to initalize.
	pause
	exit /b 1
)

REM == Sets the button bounds
set /a "x=5, y=5, width=12, height=3, bx=x + width - 1, by=y + height - 1, FPS=0, FPSCounter=0"
echo=%\e%[!y!;!x!H%\e%[38;2;0;0;0;48;2;127;127;127m%\e%7            %\e%8%\e%[B   Button   %\e%8%\e%[2B            %\e%[H

REM == Initialize FPS + DeltaTime counter ==
for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t2=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100"

(for /l %%# in () do (
	Rem FPS and DeltaTime counter
	for /f "tokens=1-4 delims=:.," %%a in ("!time: =0!") do set /a "t1=(((1%%a*60)+1%%b)*60+1%%c)*100+1%%d-36610100, deltaTime=(t1 - t2), t2=t1, counter.100cs+=deltaTime, FPSCounter+=1"
	if !counter.100cs! geq 100 (
		set /a "counter.100cs%%=100, FPS=FPSCounter, FPSCounter=0"
	)
	title FPS: !FPS! ^| DeltaTime: !deltaTime!
	
	Rem Saving variables
	set currentMouseX=!mouseXpos!
	set currentMouseY=!mouseYpos!
	
	Rem Write-only code. Do not attempt to read, you will get cancer.
	if "!highlighted!" neq "True" (
		if !currentMouseY! geq !y! if !currentMouseY! leq !by! if !currentMouseX! geq !x! if !currentMouseX! leq !bx! (
			echo=%\e%[!y!;!x!H%\e%[48;2;0;0;0;38;2;255;255;255m%\e%7            %\e%8%\e%[B   Button   %\e%8%\e%[2B            %\e%[H
			set highlighted=True
		)
	)
	if "!highlighted!"=="True" (
		%= Checking if we're not hovering over the button =%
		set highlighted=False
		if !currentMouseY! geq !y! if !currentMouseY! leq !by! if !currentMouseX! geq !x! if !currentMouseX! leq !bx! (
			set highlighted=True
		)
		if "!highlighted!"=="False" echo=%\e%[!y!;!x!H%\e%[38;2;0;0;0;48;2;127;127;127m%\e%7            %\e%8%\e%[B   Button   %\e%8%\e%[2B            %\e%[H
	)
	Rem Displaying keyboard and mouse information
	if !mouseXpos! gtr 0 if !mouseXpos! leq !this.modeW! if !mouseYpos! gtr 0 if !mouseYpos! leq !this.modeH! set /a scrollpos+=wheelDelta
	set wheelDelta=0
	set /p "=%\e%[48;2;255;255;255;38;2;0;0;0m%\e%[10;4H%\e%[2KX: !mouseXpos! Y: !mouseYpos! ^| Click: !click!%\e%[11;4H%\e%[2KKeys pressed: !keysPressed!%\e%[12;4H%\e%[2KScrolled: !scrollpos!"
)) < nul
