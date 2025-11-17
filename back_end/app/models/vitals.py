from pydantic import BaseModel
from typing import List, Optional, Dict, Any

class VitalReading(BaseModel):
    timestamp: int
    heart_rate: Optional[int] = None
    spo2: Optional[int] = None
    temperature: Optional[float] = None
    accel_x: Optional[float] = None
    accel_y: Optional[float] = None
    accel_z: Optional[float] = None
    gyro_x: Optional[float] = None
    gyro_y: Optional[float] = None
    gyro_z: Optional[float] = None
    battery: Optional[int] = None
    activity_state: Optional[str] = None

class VitalsSummary(BaseModel):
    avg_heart_rate: Optional[float] = None
    max_heart_rate: Optional[int] = None
    min_heart_rate: Optional[int] = None
    avg_spo2: Optional[float] = None
    avg_temperature: Optional[float] = None
    steps: int = 0
    calories: int = 0
    distance_km: float = 0.0
    active_minutes: int = 0
    wellness_score: Optional[int] = None

class DailyVitals(BaseModel):
    user_id: str
    date: str  # YYYY-MM-DD
    readings: List[VitalReading]
    summary: VitalsSummary
    synced_at: Optional[str] = None
