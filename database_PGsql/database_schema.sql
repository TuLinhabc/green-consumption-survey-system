/*
 * PROJECT: GREEN CONSUMPTION SURVEY SYSTEM
 * DATABASE: PostgreSQL
 * AUTHOR: linh
 * DATE: 09/06/2026
 * DESCRIPTION: Schema bao gồm các bảng khảo sát, 
 * bảng lưu kết quả phân tích thống kê đa biến.
 */

-- =========================================================
-- DATABASE SCHEMA FOR GREEN CONSUMPTION SURVEY SYSTEM
-- Topic: Ung dung phuong phap thong ke da bien cho danh gia
-- cuong do tac dong den hanh vi tieu dung xanh tren san TMĐT
-- =========================================================

CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- =========================
-- DROP TABLES IF EXISTS
-- =========================

DROP TABLE IF EXISTS analysis_results CASCADE;
DROP TABLE IF EXISTS analysis_runs CASCADE;
DROP TABLE IF EXISTS factor_scores CASCADE;
DROP TABLE IF EXISTS survey_answers CASCADE;
DROP TABLE IF EXISTS survey_responses CASCADE;
DROP TABLE IF EXISTS survey_questions CASCADE;

-- =========================
-- TABLE: survey_questions
-- =========================

CREATE TABLE survey_questions (
    id SERIAL PRIMARY KEY,
    factor_code VARCHAR(20) NOT NULL,
    question_code VARCHAR(20) NOT NULL UNIQUE,
    question_text TEXT NOT NULL,
    question_order INT NOT NULL,
    is_reverse BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: survey_responses
-- =========================

CREATE TABLE survey_responses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    buy_ecommerce_6m BOOLEAN NOT NULL,
    buy_green_product VARCHAR(50),

    gender VARCHAR(50),
    age_group VARCHAR(50),
    income_group VARCHAR(100),
    purchase_frequency VARCHAR(100),
    main_platform VARCHAR(100),

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: survey_answers
-- =========================

CREATE TABLE survey_answers (
    id BIGSERIAL PRIMARY KEY,
    response_id UUID NOT NULL,
    question_id INT NOT NULL,
    answer_value SMALLINT NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_survey_answers_response
        FOREIGN KEY (response_id)
        REFERENCES survey_responses(id)
        ON DELETE CASCADE,

    CONSTRAINT fk_survey_answers_question
        FOREIGN KEY (question_id)
        REFERENCES survey_questions(id)
        ON DELETE CASCADE,

    CONSTRAINT chk_answer_value
        CHECK (answer_value BETWEEN 1 AND 5),

    CONSTRAINT uq_response_question
        UNIQUE (response_id, question_id)
);

-- =========================
-- TABLE: factor_scores
-- =========================

CREATE TABLE factor_scores (
    response_id UUID PRIMARY KEY,

    ntmt_score NUMERIC(5, 2),
    td_score NUMERIC(5, 2),
    ahxh_score NUMERIC(5, 2),
    ntx_score NUMERIC(5, 2),
    ttt_score NUMERIC(5, 2),
    gc_score NUMERIC(5, 2),
    hvx_score NUMERIC(5, 2),

    calculated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_factor_scores_response
        FOREIGN KEY (response_id)
        REFERENCES survey_responses(id)
        ON DELETE CASCADE
);

-- =========================
-- TABLE: analysis_runs
-- =========================

CREATE TABLE analysis_runs (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    analysis_type VARCHAR(50) NOT NULL,
    sample_size INT NOT NULL,
    status VARCHAR(30) DEFAULT 'success',
    note TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- =========================
-- TABLE: analysis_results
-- =========================

CREATE TABLE analysis_results (
    id BIGSERIAL PRIMARY KEY,
    analysis_run_id UUID NOT NULL,
    result_type VARCHAR(50) NOT NULL,
    factor_code VARCHAR(20),
    result_json JSONB NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_analysis_results_run
        FOREIGN KEY (analysis_run_id)
        REFERENCES analysis_runs(id)
        ON DELETE CASCADE
);

-- =========================
-- INDEXES
-- =========================

CREATE INDEX idx_survey_questions_factor_code
ON survey_questions(factor_code);

CREATE INDEX idx_survey_answers_response_id
ON survey_answers(response_id);

CREATE INDEX idx_survey_answers_question_id
ON survey_answers(question_id);

CREATE INDEX idx_analysis_results_type
ON analysis_results(result_type);