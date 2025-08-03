@echo off

REM Specify the full path to the Anaconda's Python executable
set PYTHON_PATH=C:\Users\<your_user_name>\anaconda3\python.exe

REM Check if Anaconda's Python is accessible
if not exist "%PYTHON_PATH%" (
    echo Anaconda's Python is not installed or the path is incorrect. Please check the installation or update the path in the script.
    pause
    exit /b 1
)

REM Navigate to the directory where the script is located
cd /d "%~dp0"

REM Set the path for the virtual environment
set VENV_PATH=..\..\venv

REM Check if the virtual environment already exists
if not exist "%VENV_PATH%\Scripts\activate.bat" (
    echo Creating a new virtual environment using Anaconda's Python...
    "%PYTHON_PATH%" -m venv %VENV_PATH%
    if %errorlevel% neq 0 (
        echo Failed to create the virtual environment.
        pause
        exit /b 1
    )
) else (
    echo Activating the existing virtual environment...
)

REM Activate the virtual environment
call "%VENV_PATH%\Scripts\activate.bat"

REM Check if Python is accessible
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python was not found; please ensure it is installed correctly in the virtual environment.
    deactivate
    pause
    exit /b 1
)

REM Run the Python script using the relative path
python "..\binance_scraper.py"
if %errorlevel% neq 0 (
    echo Failed to run the Python script.
    deactivate
    pause
    exit /b 1
)

REM Deactivate the virtual environment
deactivate

pause