from sqlalchemy import (
    Column,
    Integer,
    BigInteger,
    String,
    Text,
    Boolean,
    SmallInteger,
    DateTime,
    Numeric,
    ForeignKey
)
from sqlalchemy.dialects.postgresql import UUID, JSONB
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from .database import Base
import uuid


class SurveyQuestion(Base):
    __tablename__ = "survey_questions"

    id = Column(Integer, primary_key=True, index=True)
    factor_code = Column(String(20), nullable=False)
    question_code = Column(String(20), unique=True, nullable=False)
    question_text = Column(Text, nullable=False)
    question_order = Column(Integer, nullable=False)
    is_reverse = Column(Boolean, default=False)
    created_at = Column(DateTime, server_default=func.now())


class SurveyResponse(Base):
    __tablename__ = "survey_responses"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    submitted_at = Column(DateTime, server_default=func.now())

    buy_ecommerce_6m = Column(Boolean, nullable=False)
    buy_green_product = Column(String(50))

    gender = Column(String(50))
    age_group = Column(String(50))
    income_group = Column(String(100))
    purchase_frequency = Column(String(100))
    main_platform = Column(String(100))

    created_at = Column(DateTime, server_default=func.now())

    answers = relationship(
        "SurveyAnswer",
        back_populates="response",
        cascade="all, delete-orphan"
    )


class SurveyAnswer(Base):
    __tablename__ = "survey_answers"

    id = Column(BigInteger, primary_key=True, index=True)
    response_id = Column(UUID(as_uuid=True), ForeignKey("survey_responses.id", ondelete="CASCADE"))
    question_id = Column(Integer, ForeignKey("survey_questions.id", ondelete="CASCADE"))
    answer_value = Column(SmallInteger, nullable=False)
    created_at = Column(DateTime, server_default=func.now())

    response = relationship("SurveyResponse", back_populates="answers")
    question = relationship("SurveyQuestion")


class FactorScore(Base):
    __tablename__ = "factor_scores"

    response_id = Column(UUID(as_uuid=True), ForeignKey("survey_responses.id", ondelete="CASCADE"), primary_key=True)

    ntmt_score = Column(Numeric(5, 2))
    td_score = Column(Numeric(5, 2))
    ahxh_score = Column(Numeric(5, 2))
    ntx_score = Column(Numeric(5, 2))
    ttt_score = Column(Numeric(5, 2))
    gc_score = Column(Numeric(5, 2))
    hvx_score = Column(Numeric(5, 2))

    calculated_at = Column(DateTime, server_default=func.now())


class AnalysisRun(Base):
    __tablename__ = "analysis_runs"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    analysis_type = Column(String(50), nullable=False)
    sample_size = Column(Integer, nullable=False)
    status = Column(String(30), default="success")
    note = Column(Text)
    created_at = Column(DateTime, server_default=func.now())


class AnalysisResult(Base):
    __tablename__ = "analysis_results"

    id = Column(BigInteger, primary_key=True, index=True)
    analysis_run_id = Column(UUID(as_uuid=True), ForeignKey("analysis_runs.id", ondelete="CASCADE"))
    result_type = Column(String(50), nullable=False)
    factor_code = Column(String(20))
    result_json = Column(JSONB, nullable=False)
    created_at = Column(DateTime, server_default=func.now())