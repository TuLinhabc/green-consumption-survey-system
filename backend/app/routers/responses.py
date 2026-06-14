from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from ..database import get_db
from ..models import SurveyQuestion, SurveyResponse, SurveyAnswer
from ..schemas import SurveyResponseCreate, SurveyResponseOut

router = APIRouter(
    prefix="/responses",
    tags=["Responses"]
)

@router.post("/", response_model=SurveyResponseOut)
def create_response(payload: SurveyResponseCreate, db: Session = Depends(get_db)):

    if not payload.buy_ecommerce_6m:
        raise HTTPException(
            status_code=400,
            detail="Nguoi tra loi chua tung mua hang TMĐT trong 6 thang gan day."
        )

    if len(payload.answers) != 28:
        raise HTTPException(
            status_code=400,
            detail="Phai co dung 28 cau tra loi"
        )

    codes = [a.question_code for a in payload.answers]

    if len(codes) != len(set(codes)):
        raise HTTPException(
            status_code=400,
            detail="Bi trung ma cau hoi trong phieu tra loi"
        )

    question_map = {
        q.question_code: q
        for q in db.query(SurveyQuestion).all()
    }

    invalid = set(codes) - set(question_map.keys())

    if invalid:
        raise HTTPException(
            status_code=400,
            detail=f"Cau hoi khong ton tai: {list(invalid)}"
        )

    response = SurveyResponse(
        buy_ecommerce_6m=payload.buy_ecommerce_6m,
        buy_green_product=payload.buy_green_product,
        gender=payload.gender,
        age_group=payload.age_group,
        income_group=payload.income_group,
        purchase_frequency=payload.purchase_frequency,
        main_platform=payload.main_platform
    )

    db.add(response)
    db.flush() # Tạo ID cho response để dùng cho các answer

    for answer in payload.answers:
        question = question_map[answer.question_code]

        db_answer = SurveyAnswer(
            response_id=response.id,
            question_id=question.id,
            answer_value=answer.answer_value
        )
        db.add(db_answer)

    db.commit()
    db.refresh(response)

    return response


@router.get("/", response_model=List[SurveyResponseOut])
def get_responses(db: Session = Depends(get_db)):
    responses = (
        db.query(SurveyResponse)
        .order_by(SurveyResponse.submitted_at.desc())
        .all()
    )
    return responses