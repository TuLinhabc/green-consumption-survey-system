from pydantic import BaseModel, Field
from typing import List, Optional
from uuid import UUID
from datetime import datetime


class QuestionResponse(BaseModel):
    id: int
    factor_code: str
    question_code: str
    question_text: str
    question_order: int
    is_reverse: bool

    class Config:
        from_attributes = True


class AnswerCreate(BaseModel):
    question_code: str
    answer_value: int = Field(..., ge=1, le=5)


class SurveyResponseCreate(BaseModel):
    buy_ecommerce_6m: bool
    buy_green_product: Optional[str] = None
    gender: Optional[str] = None
    age_group: Optional[str] = None
    income_group: Optional[str] = None
    purchase_frequency: Optional[str] = None
    main_platform: Optional[str] = None
    answers: List[AnswerCreate]


class SurveyResponseOut(BaseModel):
    id: UUID
    submitted_at: Optional[datetime]
    buy_ecommerce_6m: bool
    buy_green_product: Optional[str]
    gender: Optional[str]
    age_group: Optional[str]
    income_group: Optional[str]
    purchase_frequency: Optional[str]
    main_platform: Optional[str]

    class Config:
        from_attributes = True