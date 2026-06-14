from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from ..database import get_db
from ..services.preprocessing_service import build_analysis_dataframe  # ← sẽ fix sau
from ..services.efa_service import run_full_efa

router = APIRouter(prefix="/analysis", tags=["EFA"])


@router.get("/efa")
def run_efa_api(db: Session = Depends(get_db)):
    try:
        df_analysis, sample_size = build_analysis_dataframe(db)

        if df_analysis.empty or len(df_analysis) < 30:  # Ngưỡng tối thiểu cho EFA
            raise HTTPException(
                status_code=400,
                detail="Dữ liệu chưa đủ để chạy EFA (cần ít nhất 30 mẫu)"
            )

        result = run_full_efa(df_analysis)

        return {
            "status": "success",
            "sample_size": sample_size,
            **result
        }

    except Exception as e:
        # Log lỗi chi tiết (bạn xem terminal/server log)
        print(f"EFA Error: {str(e)}")  
        raise HTTPException(status_code=500, detail=f"Lỗi khi chạy EFA: {str(e)}")