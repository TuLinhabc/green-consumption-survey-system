from pathlib import Path
from typing import Dict, List, Tuple

import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from sqlalchemy.orm import Session
from sqlalchemy import text

FACTOR_ITEMS: Dict[str, List[str]] = {
    "NTMT": ["NTMT1", "NTMT2", "NTMT3", "NTMT4"],
    "TD":   ["TD1", "TD2", "TD3", "TD4"],
    "AHXH": ["AHXH1", "AHXH2", "AHXH3", "AHXH4"],
    "NTX":  ["NTX1", "NTX2", "NTX3", "NTX4_reverse"],
    "TTT":  ["TTT1", "TTT2", "TTT3", "TTT4"],
    "GC":   ["GC1", "GC2", "GC3", "GC4"],
    "HVX":  ["HVX1", "HVX2", "HVX3", "HVX4"],
}

LIKERT_COLS: List[str] = [
    "NTMT1","NTMT2","NTMT3","NTMT4",
    "TD1","TD2","TD3","TD4",
    "AHXH1","AHXH2","AHXH3","AHXH4",
    "NTX1","NTX2","NTX3","NTX4",
    "TTT1","TTT2","TTT3","TTT4",
    "GC1","GC2","GC3","GC4",
    "HVX1","HVX2","HVX3","HVX4",
]

REVERSE_ITEMS: List[str] = ["NTX4"]


def load_survey_data_from_db(db: Session) -> pd.DataFrame:
    """Load dữ liệu từ database - tối ưu và an toàn"""
    query = text("""
        SELECT
            r.id AS response_id,
            r.submitted_at,
            r.buy_ecommerce_6m,
            r.buy_green_product,
            r.gender,
            r.age_group,
            r.income_group,
            r.purchase_frequency,
            r.main_platform,
            q.question_code,
            a.answer_value
        FROM survey_responses r
        LEFT JOIN survey_answers a ON r.id = a.response_id
        LEFT JOIN survey_questions q ON a.question_id = q.id
        ORDER BY r.submitted_at, q.question_order;
    """)
    return pd.read_sql(query, db.bind)


def convert_long_to_wide(df_long: pd.DataFrame) -> pd.DataFrame:
    if df_long.empty:
        raise ValueError("Không có dữ liệu khảo sát trong database.")

    base_cols = ["response_id", "submitted_at", "buy_ecommerce_6m", "buy_green_product",
                 "gender", "age_group", "income_group", "purchase_frequency", "main_platform"]

    df_base = df_long[base_cols].drop_duplicates(subset=["response_id"]).copy()
    df_answers = df_long.pivot_table(
        index="response_id", 
        columns="question_code", 
        values="answer_value", 
        aggfunc="first"
    ).reset_index()

    return df_base.merge(df_answers, on="response_id", how="left")


def convert_likert_to_numeric(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    for col in LIKERT_COLS:
        if col in df.columns:
            df[col] = pd.to_numeric(df[col], errors="coerce")
    return df


def filter_valid_responses(df: pd.DataFrame) -> Tuple[pd.DataFrame, pd.DataFrame]:
    df = df.copy()
    df["invalid_reason"] = ""

    # 1. Not eligible
    not_buy_mask = df["buy_ecommerce_6m"].astype(str).str.lower().isin(["false", "0", "no", "khong", "không"])
    df.loc[not_buy_mask, "invalid_reason"] += "NOT_ELIGIBLE; "

    # 2. Logic Inconsistency
    if "buy_green_product" in df.columns:
        logic_inconsistent_mask = df["buy_green_product"].notna() & not_buy_mask
        df.loc[logic_inconsistent_mask, "invalid_reason"] += "LOGIC_INCONSISTENCY; "

    # 3. Missing value
    missing_mask = df[LIKERT_COLS].isna().any(axis=1)
    df.loc[missing_mask, "invalid_reason"] += "MISSING_VALUE; "

    # 4. Out of range
    out_mask = ~df[LIKERT_COLS].apply(lambda s: s.between(1, 5)).all(axis=1)
    df.loc[out_mask, "invalid_reason"] += "OUT_OF_RANGE; "

    # 5. Low variance (cột hằng số)
    low_var_cols = df[LIKERT_COLS].var() < 0.01
    if low_var_cols.any():
        df.loc[:, "invalid_reason"] += "LOW_VARIANCE; "

    invalid_df = df[df["invalid_reason"] != ""].copy()
    valid_df = df[df["invalid_reason"] == ""].copy()

    invalid_df["invalid_reason"] = invalid_df["invalid_reason"].str.strip("; ")
    return valid_df, invalid_df


def handle_reverse_items(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    for item in REVERSE_ITEMS:
        if item in df.columns:
            df[f"{item}_reverse"] = 6 - df[item]
    return df


def calculate_factor_scores(df: pd.DataFrame) -> pd.DataFrame:
    df = df.copy()
    for factor_code, item_cols in FACTOR_ITEMS.items():
        valid_items = [col for col in item_cols if col in df.columns]
        if valid_items:
            df[factor_code] = df[valid_items].mean(axis=1, skipna=True).round(3)
    return df


def build_analysis_dataframe(db: Session) -> Tuple[pd.DataFrame, pd.DataFrame]:
    """Hàm chính - trả về df_analysis và df_invalid"""
    df_long = load_survey_data_from_db(db)
    df_wide = convert_long_to_wide(df_long)
    df_wide = convert_likert_to_numeric(df_wide)

    df_valid, df_invalid = filter_valid_responses(df_wide)
    df_analysis = handle_reverse_items(df_valid)
    df_analysis = calculate_factor_scores(df_analysis)

    return df_analysis, df_invalid


def get_final_dataset(df_analysis: pd.DataFrame) -> pd.DataFrame:
    cols = ["response_id", "NTMT", "TD", "AHXH", "NTX", "TTT", "GC", "HVX"]
    existing_cols = [col for col in cols if col in df_analysis.columns]
    return df_analysis[existing_cols].copy()


def export_analysis_data(df_analysis: pd.DataFrame, df_invalid: pd.DataFrame, output_dir: str = "exports"):
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)

    paths = {
        "clean_csv": output_path / "du_lieu_sach_phan_tich.csv",
        "clean_excel": output_path / "du_lieu_sach_phan_tich.xlsx",
        "invalid_csv": output_path / "du_lieu_bi_loai.csv",
        "invalid_excel": output_path / "du_lieu_bi_loai.xlsx",
        "factor_excel": output_path / "du_lieu_nhan_to.xlsx"
    }

    df_analysis.to_csv(paths["clean_csv"], index=False, encoding="utf-8-sig")
    df_analysis.to_excel(paths["clean_excel"], index=False)
    df_invalid.to_csv(paths["invalid_csv"], index=False, encoding="utf-8-sig")
    df_invalid.to_excel(paths["invalid_excel"], index=False)

    get_final_dataset(df_analysis).to_excel(paths["factor_excel"], index=False)

    return {k: str(v) for k, v in paths.items()}