from pydantic import BaseModel
from typing import Optional

class UserProfileResponse(BaseModel):
    user_id: str
    age: Optional[int] = None
    gender: Optional[str] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    activity_level: Optional[str] = None
    has_hypertension: bool = False
    has_diabetes: bool = False
    has_heart_condition: bool = False
    medications: Optional[str] = None
    allergies: Optional[str] = None
    goal_type: Optional[str] = None
    goal_intensity: Optional[str] = None
    target_weight_kg: Optional[float] = None
    daily_calorie_goal: int = 2000
    daily_step_goal: int = 10000
    daily_distance_goal: float = 5.0
    daily_active_minutes_goal: int = 30
    daily_protein_goal: int = 150
    daily_carbs_goal: int = 250
    daily_fats_goal: int = 70
    updated_at: Optional[str] = None

class UpdateProfileRequest(BaseModel):
    age: Optional[int] = None
    gender: Optional[str] = None
    weight_kg: Optional[float] = None
    height_cm: Optional[float] = None
    activity_level: Optional[str] = None
    has_hypertension: Optional[bool] = None
    has_diabetes: Optional[bool] = None
    has_heart_condition: Optional[bool] = None
    medications: Optional[str] = None
    allergies: Optional[str] = None
    goal_type: Optional[str] = None
    goal_intensity: Optional[str] = None
    target_weight_kg: Optional[float] = None
    daily_calorie_goal: Optional[int] = None
    daily_step_goal: Optional[int] = None
    daily_distance_goal: Optional[float] = None
    daily_active_minutes_goal: Optional[int] = None
    daily_protein_goal: Optional[int] = None
    daily_carbs_goal: Optional[int] = None
    daily_fats_goal: Optional[int] = None
