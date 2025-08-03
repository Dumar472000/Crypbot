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
if exist "%VENV_PATH%\Scripts\activate.bat" (
    echo Virtual environment already exists.
) else (
    echo Creating a new virtual environment using Anaconda's Python...
    "%PYTHON_PATH%" -m venv %VENV_PATH%
    if %errorlevel% neq 0 (
        echo Failed to create the virtual environment.
        pause
        exit /b 1
    )
)

REM Activate the virtual environment
echo Activating the virtual environment...
call "%VENV_PATH%\Scripts\activate.bat"

REM Check if Python is accessible in the virtual environment
python --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Python was not found; please ensure it is installed correctly in the virtual environment.
    deactivate
    pause
    exit /b 1
)

REM Check if requirements.txt exists in the specified path
set REQUIREMENTS_PATH=..\..\requirements\requirements.txt
if exist "%REQUIREMENTS_PATH%" (
    echo Installing packages from %REQUIREMENTS_PATH%...
    @REM pip install -r "%REQUIREMENTS_PATH%"
    pip install --use-deprecated=legacy-resolver -r "%REQUIREMENTS_PATH%"
    if %errorlevel% neq 0 (
        echo Failed to install required packages.
        deactivate
        pause
        exit /b 1
    )
) else (
    echo %REQUIREMENTS_PATH% not found. Please ensure the file is in the correct location.
    deactivate
    pause
    exit /b 1
)

REM Deactivate the virtual environment
echo Deactivating the virtual environment...
deactivate

echo Environment setup complete.
pause