from pydantic import BaseModel, EmailStr, Field
from typing import Optional
from datetime import datetime

class User(BaseModel):
    id: Optional[str] = None
    email: EmailStr
    username: str
    full_name: str
    created_at: str = Field(default_factory=lambda: datetime.utcnow().isoformat())
    last_login: Optional[str] = None

class UserProfile(BaseModel):
    user_id: str
    age: Optional[int] = None
    gender: Optional[str] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    activity_level: Optional[str] = "moderate"  # sedentary, light, moderate, active, very_active
    
    # Health conditions
    has_hypertension: bool = False
    has_diabetes: bool = False
    has_heart_condition: bool = False
    medications: Optional[str] = None
    allergies: Optional[str] = None
    
    # Goals
    goal_type: Optional[str] = "maintain_weight"  # lose_weight, gain_weight, maintain_weight, build_muscle
    goal_intensity: Optional[str] = "moderate"
    target_weight_kg: Optional[float] = None
    
    # Daily targets
    daily_calorie_goal: int = 2000
    daily_step_goal: int = 10000
    daily_distance_goal: float = 5.0  # km
    daily_active_minutes_goal: int = 30
    daily_protein_goal: int = 150  # grams
    daily_carbs_goal: int = 250
    daily_fats_goal: int = 70
    
    updated_at: str = Field(default_factory=lambda: datetime.utcnow().isoformat())
