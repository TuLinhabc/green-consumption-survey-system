import numpy as np
import pandas as pd
import math


def cronbach_alpha(df: pd.DataFrame):
    if df.empty or df.shape[1] == 0:
        return 0.0

    df = df.copy()

    # Ép kiểu numeric
    df = df.apply(pd.to_numeric, errors='coerce')

    # Fill NaN bằng mean của từng cột
    df = df.fillna(df.mean())

    k = df.shape[1]

    if k < 2:
        return 0.0

    item_variances = df.var(axis=0, ddof=1)
    total_score = df.sum(axis=1)
    total_variance = total_score.var(ddof=1)

    # Xử lý trường hợp variance = 0 hoặc NaN
    if total_variance == 0 or math.isnan(total_variance) or math.isinf(total_variance):
        return 0.0

    alpha = (k / (k - 1)) * (1 - item_variances.sum() / total_variance)

    # Xử lý NaN/Inf cuối cùng
    if math.isnan(alpha) or math.isinf(alpha):
        return 0.0

    return round(float(alpha), 4)


def run_cronbach(df: pd.DataFrame, items: list, factor_name: str):
    """Chạy Cronbach cho một factor"""
    cols = [c for c in items if c in df.columns]

    if len(cols) < 2:
        return {
            "factor": factor_name,
            "alpha": 0.0,
            "items": cols,
            "note": f"Không đủ cột hợp lệ (chỉ có {len(cols)} cột)"
        }

    subset = df[cols]
    alpha = cronbach_alpha(subset)

    return {
        "factor": factor_name,
        "alpha": alpha,
        "items": cols
    }


def run_all_cronbach(df: pd.DataFrame):
    """Chạy Cronbach cho tất cả các factor"""
    factors = {
        "NTMT": ["NTMT1", "NTMT2", "NTMT3", "NTMT4"],
        "TD":   ["TD1", "TD2", "TD3", "TD4"],
        "AHXH": ["AHXH1", "AHXH2", "AHXH3", "AHXH4"],
        "NTX":  ["NTX1", "NTX2", "NTX3", "NTX4_reverse"],
        "TTT":  ["TTT1", "TTT2", "TTT3", "TTT4"],
        "GC":   ["GC1", "GC2", "GC3", "GC4"],
        "HVX":  ["HVX1", "HVX2", "HVX3", "HVX4"],
    }

    results = []
    for name, items in factors.items():
        result = run_cronbach(df, items, name)
        results.append(result)

    return results