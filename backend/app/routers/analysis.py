from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..database import get_db
from ..services.preprocessing_service import (
    build_analysis_dataframe,
    export_analysis_data,
    
)

router = APIRouter(
    prefix="/analysis",
    tags=["Analysis"],
)


@router.post("/run-preprocessing")
def run_preprocessing(db: Session = Depends(get_db)):
    df_analysis, df_invalid = build_analysis_dataframe(db)

    exported_files = export_analysis_data(
        df_analysis=df_analysis,
        df_invalid=df_invalid,
        output_dir="exports",
    )

    return {
        "message": "Tiền xử lý dữ liệu thành công",
        "exported_files": exported_files,
    }

@router.get("/debug-counts")
def debug_counts(db: Session = Depends(get_db)):
    from sqlalchemy import text

    responses_count = db.execute(
        text("SELECT COUNT(*) FROM survey_responses")
    ).scalar()

    answers_count = db.execute(
        text("SELECT COUNT(*) FROM survey_answers")
    ).scalar()

    questions_count = db.execute(
        text("SELECT COUNT(*) FROM survey_questions")
    ).scalar()

    join_count = db.execute(
        text("""
            SELECT COUNT(*)
            FROM survey_responses r
            JOIN survey_answers a ON r.id = a.response_id
            JOIN survey_questions q ON a.question_id = q.id
        """)
    ).scalar()

    return {
        "survey_responses": responses_count,
        "survey_answers": answers_count,
        "survey_questions": questions_count,
        "join_rows": join_count,
    }