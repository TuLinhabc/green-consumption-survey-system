from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from typing import List

from ..database import get_db
from ..models import SurveyQuestion
from ..schemas import QuestionResponse

router = APIRouter(
    prefix="/questions",
    tags=["Questions"]
)


@router.get("/", response_model=List[QuestionResponse])
def get_questions(db: Session = Depends(get_db)):
    questions = (
        db.query(SurveyQuestion)
        .order_by(SurveyQuestion.question_order.asc())
        .all()
    )
    return questions