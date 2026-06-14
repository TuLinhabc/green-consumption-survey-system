from fastapi import FastAPI
from .routers import questions, responses, analysis
from app.routers import analysis_cronbach
from app.routers import analysis_efa
from app.routers import analysis_regression

app = FastAPI(
    title="Green Consumption Survey API",
    description="Backend API for green consumption behavior survey and multivariate statistics analysis.",
    version="1.0.0"
)

app.include_router(questions.router)
app.include_router(responses.router)
app.include_router(analysis.router)
app.include_router(analysis_cronbach.router)
app.include_router(analysis_efa.router)
app.include_router(analysis_regression.router)

@app.get("/")
def root():
    return {
        "message": "Green Consumption Survey API is running"
    }