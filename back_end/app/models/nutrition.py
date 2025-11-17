from pydantic import BaseModel
from typing import Optional

class NutritionEntry(BaseModel):
    id: Optional[str] = None
    user_id: str
    timestamp: int
    meal_type: str  # breakfast, lunch, dinner, snack
    calories: int
    protein_g: float
    carbs_g: float
    fats_g: float
    fiber_g: Optional[float] = None
    sugar_g: Optional[float] = None
    sodium_mg: Optional[float] = None
    image_url: Optional[str] = None
    description: Optional[str] = None
    food_items: Optional[str] = None  # Comma-separated list
