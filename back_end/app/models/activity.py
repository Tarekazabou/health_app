from pydantic import BaseModel
from typing import List, Optional, Dict

class HourlyActivity(BaseModel):
    hour: int  # 0-23
    steps: int = 0
    calories: int = 0
    distance_km: float = 0.0
    active_minutes: int = 0

class DailyActivity(BaseModel):
    user_id: str
    date: str  # YYYY-MM-DD
    steps: int = 0
    distance_km: float = 0.0
    active_minutes: int = 0
    calories_burned: int = 0
    hourly_breakdown: Optional[List[HourlyActivity]] = []
    synced_at: Optional[str] = None

class Session(BaseModel):
    id: Optional[str] = None
    user_id: str
    session_type: str  # walking, running, cycling, workout, etc.
    start_time: int  # timestamp
    end_time: int  # timestamp
    duration_seconds: int
    avg_heart_rate: Optional[int] = None
    max_heart_rate: Optional[int] = None
    calories_burned: Optional[int] = None
    avg_spo2: Optional[int] = None
    distance_km: Optional[float] = None
    steps: Optional[int] = None
    notes: Optional[str] = None
