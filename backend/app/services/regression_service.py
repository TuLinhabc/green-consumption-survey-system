import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.stats.api as sms
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.stats.diagnostic import het_breuschpagan
import warnings
warnings.filterwarnings("ignore")

from typing import Dict, List, Tuple


def run_multiple_regression(df: pd.DataFrame, 
                           dependent_var: str = "GC",
                           independent_vars: List[str] = None) -> Dict:
    """
    Thực hiện Multiple Linear Regression chuẩn SPSS
    """
    if independent_vars is None:
        independent_vars = ["NTMT", "TD", "AHXH", "NTX", "TTT", "HVX"]

    # Kiểm tra cột tồn tại
    available_iv = [var for var in independent_vars if var in df.columns]
    if dependent_var not in df.columns or len(available_iv) == 0:
        return {"status": "error", "message": "Thiếu biến phụ thuộc hoặc độc lập"}

    X = df[available_iv].copy()
    y = df[dependent_var].copy()

    # Thêm hằng số (intercept)
    X = sm.add_constant(X)

    # Fit model
    model = sm.OLS(y, X).fit()

    # ================== MODEL SUMMARY ==================
    model_summary = {
        "R": round(np.sqrt(model.rsquared), 4),
        "R_squared": round(model.rsquared, 4),
        "Adj_R_squared": round(model.rsquared_adj, 4),
        "F_statistic": round(model.fvalue, 4),
        "F_pvalue": round(model.f_pvalue, 6),
        "n_observations": int(model.nobs),
        "dependent_var": dependent_var,
        "independent_vars": available_iv
    }

    # ================== ANOVA TABLE ==================
    anova_table = {
        "Regression": {
            "df": model.df_model,
            "sum_sq": round(model.ess, 4),
            "mean_sq": round(model.mse_model, 4),
            "F": round(model.fvalue, 4),
            "Sig": round(model.f_pvalue, 6)
        },
        "Residual": {
            "df": model.df_resid,
            "sum_sq": round(model.ssr, 4),
            "mean_sq": round(model.mse_resid, 4)
        },
        "Total": {
            "df": model.df_model + model.df_resid,
            "sum_sq": round(model.ssr + model.ess, 4)
        }
    }

    # ================== COEFFICIENTS TABLE ==================
    coef_table = []
    for i, var in enumerate(X.columns):
        coef_table.append({
            "Variable": var,
            "B": round(model.params[i], 4),
            "Std_Error": round(model.bse[i], 4),
            "Beta": round(model.params[i] * X.iloc[:, i].std() / y.std(), 4) if i > 0 else 0.0,
            "t": round(model.tvalues[i], 4),
            "p_value": round(model.pvalues[i], 6),
            "Sig": "***" if model.pvalues[i] < 0.001 else "**" if model.pvalues[i] < 0.01 else "*" if model.pvalues[i] < 0.05 else "ns"
        })

    # ================== MULTICOLLINEARITY (VIF) ==================
    vif_data = []
    for i in range(1, len(X.columns)):  # Bỏ const
        vif = variance_inflation_factor(X.values, i)
        vif_data.append({
            "Variable": X.columns[i],
            "VIF": round(vif, 2)
        })

    # ================== ASSUMPTIONS CHECK ==================
    # Breusch-Pagan test for heteroscedasticity
    try:
        bp_test = het_breuschpagan(model.resid, model.model.exog)
        heteroscedasticity = {
            "Breusch_Pagan_Chi2": round(bp_test[0], 4),
            "p_value": round(bp_test[1], 6),
            "interpretation": "Không có heteroscedasticity" if bp_test[1] > 0.05 else "Có heteroscedasticity (vi phạm)"
        }
    except:
        heteroscedasticity = {"status": "Không tính được"}

    residuals = model.resid
    assumptions = {
        "normality_shapiro_p": round(sm.stats.stattools.shapiro(residuals)[1], 6),
        "heteroscedasticity": heteroscedasticity,
        "durbin_watson": round(sm.stats.stattools.durbin_watson(residuals), 4)
    }

    return {
        "status": "success",
        "model_summary": model_summary,
        "anova_table": anova_table,
        "coefficients": coef_table,
        "vif": vif_data,
        "assumptions": assumptions,
        "model_fit": {
            "AIC": round(model.aic, 2),
            "BIC": round(model.bic, 2)
        }
    }


def run_all_regressions(df: pd.DataFrame) -> Dict:
    """
    Chạy nhiều mô hình regression phổ biến trong luận văn
    """
    results = {}

    # Mô hình chính: Tất cả yếu tố → Hành vi tiêu dùng xanh (GC)
    results["full_model"] = run_multiple_regression(df, dependent_var="GC")

    # Mô hình phụ: Mỗi nhóm yếu tố riêng lẻ
    for factor in ["NTMT", "TD", "AHXH", "NTX", "TTT", "HVX"]:
        if factor in df.columns:
            results[f"{factor}_model"] = run_multiple_regression(
                df, 
                dependent_var="GC", 
                independent_vars=[factor]
            )

    return {
        "status": "success",
        "sample_size": len(df),
        "results": results
    }