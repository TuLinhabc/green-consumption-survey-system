from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from .routers import questions, responses, analysis
from app.routers import analysis_cronbach, analysis_efa, analysis_regression

app = FastAPI(
    title="Green Consumption Survey API",
    description="Backend API for green consumption behavior survey and multivariate statistics analysis.",
    version="1.0.0"
)

# ================== CORS - RẤT QUAN TRỌNG CHO FLUTTER WEB ==================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],           # Cho phép tất cả (dev). Sau này thay bằng domain cụ thể
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(questions.router)
app.include_router(responses.router)
app.include_router(analysis.router)
app.include_router(analysis_cronbach.router)
app.include_router(analysis_efa.router)
app.include_router(analysis_regression.router)

@app.get("/")
def root():
    return {"message": "Green Consumption Survey API is running"}