from pydantic import BaseModel
from typing import Optional

class Alert(BaseModel):
    id: Optional[str] = None
    user_id: str
    timestamp: int
    severity: str  # critical, warning, info
    vital_type: str  # heart_rate, spo2, temperature, activity
    message: str
    recommendation: Optional[str] = None
    vital_value: Optional[float] = None
    acknowledged: bool = False
    acknowledged_at: Optional[int] = None
