from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..services.preprocessing_service import build_analysis_dataframe
from ..services.regression_service import run_all_regressions

router = APIRouter(prefix="/analysis", tags=["Regression"])


@router.get("/regression")
def run_regression_api(db: Session = Depends(get_db)):
    try:
        df_analysis, _ = build_analysis_dataframe(db)

        if len(df_analysis) < 50:
            raise HTTPException(
                status_code=400,
                detail="Số mẫu quá ít để chạy Regression (khuyến nghị ≥ 50)"
            )

        result = run_all_regressions(df_analysis)

        return result

    except Exception as e:
        print(f"Regression Error: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Lỗi khi chạy Regression: {str(e)}")