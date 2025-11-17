#!/bin/bash

echo "========================================"
echo "Starting HealthTrack Backend API"
echo "========================================"
echo ""

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv venv
    echo ""
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate
echo ""

# Install dependencies
echo "Installing dependencies..."
pip install -r requirements.txt
echo ""

# Check for .env file
if [ ! -f ".env" ]; then
    echo "WARNING: .env file not found!"
    echo "Copying .env.example to .env..."
    cp .env.example .env
    echo "Please edit .env file with your Firebase credentials"
    echo ""
fi

# Start the server
echo "Starting FastAPI server..."
echo "API Documentation: http://localhost:8000/docs"
echo "Health Check: http://localhost:8000/health"
echo ""
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
