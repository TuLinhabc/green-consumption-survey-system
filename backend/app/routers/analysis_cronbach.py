from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from ..database import get_db
from ..services.preprocessing_service import build_analysis_dataframe
from ..services.cronbach_service import run_cronbach

router = APIRouter(prefix="/analysis", tags=["Cronbach"])


@router.get("/cronbach")
def cronbach_analysis(db: Session = Depends(get_db)):
    df_analysis, _ = build_analysis_dataframe(db)

    factors = {
        "NTMT": ["NTMT1", "NTMT2", "NTMT3", "NTMT4"],
        "TD": ["TD1", "TD2", "TD3", "TD4"],
        "AHXH": ["AHXH1", "AHXH2", "AHXH3", "AHXH4"],
        "NTX": ["NTX1", "NTX2", "NTX3", "NTX4_reverse"],
        "TTT": ["TTT1", "TTT2", "TTT3", "TTT4"],
        "GC": ["GC1", "GC2", "GC3", "GC4"],
        "HVX": ["HVX1", "HVX2", "HVX3", "HVX4"],
    }

    results = []

    for name, cols in factors.items():

        # ❗ kiểm tra thiếu cột
        missing = [c for c in cols if c not in df_analysis.columns]
        if missing:
            continue

        subset = df_analysis[cols]

        result = run_cronbach(subset, cols, name)
        results.append(result)

    return {
        "status": "success",
        "results": results
    }