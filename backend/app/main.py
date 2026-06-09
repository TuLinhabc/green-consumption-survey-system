from fastapi import FastAPI
from .routers import questions, responses

app = FastAPI(
    title="Green Consumption Survey API",
    description="Backend API for green consumption behavior survey and multivariate statistics analysis.",
    version="1.0.0"
)

app.include_router(questions.router)
app.include_router(responses.router)


@app.get("/")
def root():
    return {
        "message": "Green Consumption Survey API is running"
    }