<div align="center">
  
## Shivter's GetInput documentation
A document containing everything about the GetInput DLL extension.
</div>

# Injection
To use GetInput in your projects, you need to start off by injecting it into your CMD session.

Here, we'll assume you're in the same directory as the DLL file, and we'll be using the 64 bit version.

We'll also check if GetInput was injected successfully by checking the `getInputInitialized` variable.

```bat
@echo off & setlocal enableDelayedExpansion
if exist getInput64.dll rundll32.exe "getInput64.dll",inject
if not defined getInputInitialized (
  echo GetInput failed to initialize.
  exit /b 1
)
```

# Using GetInput
GetInput works in a way where it injects into CMD.EXE and modifies some variables that can be expanded to get user inputs.

These variables are modified in real time, which means that we can get user input from these variables instantly.

When making multiple checks on the same variable in a frame/tick, it's recommended to first save the variables into other variables so that input skipping doesn't happen.

## Mouse input
To start off, let's make a simple program that tells us our mouse position & click state on the console in real time with an infinite loop.

To do that, we'll use the following variables: `mouseXpos`, `mouseYpos`, `click`

We'll also use some escape sequences for the graphics.
```bat
@echo off & setlocal enableDelayedExpansion
if exist getInput64.dll rundll32.exe "getInput64.dll",inject
if not defined getInputInitialized (
  echo GetInput failed to initialize.
  exit /b 1
)
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
echo=%\e%[H%\e%[48;2;255;255;255m%\e%[38;2;0;0;0m%\e%[2J%\e%[?25l
for /l %%# in () do (
  echo=%\e%[H%\e%[2KX: !mouseXpos!, Y: !mouseYpos!, Click: !click!
)
```

## Keyboard input
Of course, what would be user input without keypresses?

We can get key input by parsing the `keysPressed` variable which contains keycodes of keys that are currently *held*, surrounded & seperated by dashes (`-`). Keep that in mind.

Examples:
- When ESC is held: `-27-`
- When A is held: `-65-`
- When SHIFT + A is held: `-16-65-`
```bat
@echo off & setlocal enableDelayedExpansion
if exist getInput64.dll rundll32.exe "getInput64.dll",inject
if not defined getInputInitialized (
  echo GetInput failed to initialize.
  exit /b 1
)
for /f %%a in ('echo prompt $E^| cmd') do set "\e=%%a"
echo=%\e%[H%\e%[48;2;255;255;255m%\e%[38;2;0;0;0m%\e%[2J%\e%[?25l
for /l %%# in () do (
  echo=%\e%[H%\e%[2KKeys pressed: !keysPressed!
)
```

## Controller input
GetInput can get input from up to 4 controllers.

Controller ports may be assigned in any order, but if possible preferably starting with the controller which has been plugged in for the longest.

If controllers 1 and 2 are connected, controller 1 is disconnected, controller 2 should stay as controller 2, and the next connected controller becomes controller 1.

As for output, two-state face buttons such as ABXY, select, option, the XBox logo button, and LB/RB should be in the `controllerX_buttons` variable
Ihis variable is in the format of `-A-B-SELECT-LB-` with only the held buttons being present in the variable.

The order of these buttons if all are pressed are `-A-B-X-Y-LB-RB-DPADUP-DPADDOWN-DPadLeft-DPADRIGHT-LSTICKDOWN-RSTICKDOWN-SEL-OPTIONS-HOME-`

For non two-state stuff (sticks and triggers), these will be stored in the `controllerX_numbers` variable.

This variable is in the format of: `-0-0-0-0-0-0-`

This variables doesn't vary in entries like the others do, it should always have 6 values inside.

The first 0 is the left bumper trigger,

the second 0 is the right bumper trigger,

the third 0 is the left stick X,

the fourth 0 is the left stick Y,

the fifth 0 is the right stick X,

the sixth 0 is the right stick Y.

## Tips & Tricks
If you want to check if specific keys are held, Save the `keysPressed` variable to some thing else (`last.keysPressed` in this example) and use this (example key: ESC):
```bat
if defined last.keysPressed if "!last.keysPressed!" neq "!last.keysPressed:-27-=!" ...
```

<div align="right">

Copyright Shivter 2021 - 2024 | Sources: [ANSI Escape Codes by fnky](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls)
</div>
