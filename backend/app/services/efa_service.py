import pandas as pd
import numpy as np
import warnings
warnings.filterwarnings("ignore")

from factor_analyzer import FactorAnalyzer
from factor_analyzer.factor_analyzer import calculate_kmo, calculate_bartlett_sphericity


def prepare_efa_data(df: pd.DataFrame, items: list):
    df = df.copy()
    cols = [c for c in items if c in df.columns]
    
    if len(cols) < 5:
        raise ValueError("Không đủ biến để chạy EFA")

    df = df[cols]
    df = df.apply(pd.to_numeric, errors='coerce')
    df = df.fillna(df.mean())

    # Loại bỏ cột có phương sai = 0 (gây lỗi)
    df = df.loc[:, df.var() > 0.0001]

    return df


def run_kmo(df: pd.DataFrame):
    try:
        kmo_all, kmo_model = calculate_kmo(df)
        return {
            "KMO_Model": round(float(kmo_model), 4),
            "KMO_Items": [round(float(x), 4) for x in kmo_all]
        }
    except Exception as e:
        return {"error": str(e), "KMO_Model": 0.0}


def run_bartlett(df: pd.DataFrame):
    try:
        chi_square, p_value = calculate_bartlett_sphericity(df)
        return {
            "ChiSquare": round(float(chi_square), 4),
            "p_value": round(float(p_value), 6)
        }
    except Exception as e:
        return {"error": str(e)}


def run_efa(df: pd.DataFrame, n_factors: int = 7):
    try:
        fa = FactorAnalyzer(n_factors=n_factors, rotation="varimax", method='principal')
        fa.fit(df)

        eigenvalues, _ = fa.get_eigenvalues()
        loadings = pd.DataFrame(fa.loadings_, index=df.columns)

        variance = fa.get_factor_variance()

        return {
            "eigenvalues": [round(float(x), 4) for x in eigenvalues],
            "factor_loadings": loadings.round(4).to_dict(orient='index'),
            "explained_variance": [round(float(x), 4) for x in variance[1]],
            "cumulative_variance": [round(float(x), 4) for x in variance[2]]
        }
    except Exception as e:
        raise ValueError(f"Lỗi khi chạy EFA: {str(e)}")


def run_full_efa(df: pd.DataFrame):
    items = [
        "NTMT1","NTMT2","NTMT3","NTMT4",
        "TD1","TD2","TD3","TD4",
        "AHXH1","AHXH2","AHXH3","AHXH4",
        "NTX1","NTX2","NTX3","NTX4_reverse",
        "TTT1","TTT2","TTT3","TTT4",
        "GC1","GC2","GC3","GC4",
        "HVX1","HVX2","HVX3","HVX4"
    ]

    df_clean = prepare_efa_data(df, items)

    kmo = run_kmo(df_clean)
    bartlett = run_bartlett(df_clean)
    efa = run_efa(df_clean, n_factors=7)

    return {
        "status": "success",
        "kmo": kmo,
        "bartlett": bartlett,
        "efa": efa
    }