@echo off
echo ========================================
echo Starting HealthTrack Backend API
echo ========================================
echo.

REM Check if virtual environment exists
if not exist "venv\" (
    echo Creating virtual environment...
    python -m venv venv
    echo.
)

REM Activate virtual environment
echo Activating virtual environment...
call venv\Scripts\activate.bat
echo.

REM Install dependencies
echo Installing dependencies...
pip install -r requirements.txt
echo.

REM Check for .env file
if not exist ".env" (
    echo WARNING: .env file not found!
    echo Copying .env.example to .env...
    copy .env.example .env
    echo Please edit .env file with your Firebase credentials
    echo.
)

REM Start the server
echo Starting FastAPI server...
echo API Documentation: http://localhost:8000/docs
echo Health Check: http://localhost:8000/health
echo.
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
