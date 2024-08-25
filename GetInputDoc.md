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

We can get key input by parsing the `keysPressed` variable which contains keycodes of keys that are currently *held*. Keep that in mind.
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
< documentation comming soon >

<div align="right">

Copyright Shivter 2021 - 2024 | Sources: [ANSI Escape Codes by fnky](https://gist.github.com/fnky/458719343aabd01cfb17a3a4f7296797#cursor-controls)
</div>
