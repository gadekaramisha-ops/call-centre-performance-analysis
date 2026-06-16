-- =====================================================================
-- 01_basic_kpis.sql
-- Project:  Operations & Resource Optimization (Q1 2021 Call Centre)
-- Author:   Amisha Gadekar
-- Purpose:  Analyse call centre performance using progressively deeper
--           slicing techniques to surface actionable insights.
-- 
-- Contents:
--   Query 1: Headline call centre KPIs
--   Query 2: Hourly call volume + answer rate
--   Query 3: Performance by topic
--   Query 4: Agent leaderboard
--   Query 5: Agent × topic specialisation (CTE + window function)
-- =====================================================================

USE call_center;
-- ---------------------------------------------------------------------
-- Query 1: Overall call centre KPIs
-- Returns a single row with: total calls, answer rate, resolution rate,
-- average satisfaction, and average handle time.
-- ---------------------------------------------------------------------

SELECT
    COUNT(*)                                                AS total_calls,
    ROUND(AVG(answered_flag) * 100, 1)                      AS answer_rate_pct,
    ROUND(SUM(resolved_flag) * 100.0 / SUM(answered_flag),1) AS resolution_rate_pct,
    ROUND(AVG(satisfaction_rating), 2)                      AS avg_satisfaction,
    ROUND(AVG(speed_of_answer_sec), 1)                      AS avg_speed_of_answer_sec,
    ROUND(AVG(avg_talk_duration_sec), 1)                    AS avg_talk_duration_sec
FROM calls;

-- ---------------------------------------------------------------------
-- Query 2: Hourly call volume + answer rate
-- Investigates whether unanswered calls cluster around peak hours.
-- ---------------------------------------------------------------------

SELECT
    call_hour,
    COUNT(*)                                 AS total_calls,
    SUM(answered_flag)                       AS answered_calls,
    SUM(1 - answered_flag)                   AS unanswered_calls,
    ROUND(AVG(answered_flag) * 100, 1)       AS answer_rate_pct,
    ROUND(AVG(speed_of_answer_sec), 1)       AS avg_speed_of_answer_sec
FROM calls
GROUP BY call_hour
ORDER BY call_hour;

-- INSIGHT (Query 2):
-- Answer rate is consistently 79–82% across all operating hours
-- (excluding 6 PM, n=14, statistically negligible).
-- 12 PM dips slightly to 78.8% — likely thinner lunch coverage, but a
-- minor pattern. The 19% unanswered rate is therefore a system-level
-- capacity gap, not a peak-hour bottleneck.
-- Recommendation: increase baseline headcount across operating hours
-- rather than scheduling a lunch-time spike.

-- ---------------------------------------------------------------------
-- Query 3: Performance breakdown by topic
-- Compares call types to identify which topics drag down satisfaction
-- or have the worst service metrics.
-- ---------------------------------------------------------------------

SELECT
    topic,
    COUNT(*)                                                    AS total_calls,
    ROUND(AVG(answered_flag) * 100, 1)                          AS answer_rate_pct,
    ROUND(SUM(resolved_flag) * 100.0 / SUM(answered_flag), 1)   AS resolution_rate_pct,
    ROUND(AVG(satisfaction_rating), 2)                          AS avg_satisfaction,
    ROUND(AVG(avg_talk_duration_sec), 1)                        AS avg_talk_duration_sec
FROM calls
GROUP BY topic
ORDER BY total_calls DESC;
-- INSIGHT (Query 3):
-- Topic-level performance is remarkably uniform:
--   - Satisfaction spread: only 0.05 points (3.38–3.43)
--   - Resolution spread:  only 3 points (88.4%–91.4%)
--   - Answer rate spread: only 4 points (79.0%–82.9%)
-- No single topic drags the operation down or stands out as a star.
--
-- COMBINED FINDING (Queries 1–3):
-- Performance is consistent across agents, hours, and topics. The 
-- 19% unanswered rate and 3.4/5 satisfaction are SYSTEMIC issues, 
-- not concentrated in any specific dimension. This points to 
-- structural causes (capacity, routing) rather than localised ones 
-- (specific agent coaching, peak-hour staffing, or topic specialisation).
-- ---------------------------------------------------------------------
-- Query 4: Agent performance leaderboard
-- Per-agent KPIs, sorted by resolution rate (best on top).
-- This recreates in SQL the same leaderboard built in Python in Step 1.
-- ---------------------------------------------------------------------

SELECT
    agent,
    COUNT(*)                                                    AS total_calls,
    SUM(answered_flag)                                          AS answered_calls,
    SUM(resolved_flag)                                          AS resolved_calls,
    ROUND(AVG(answered_flag) * 100, 1)                          AS answer_rate_pct,
    ROUND(SUM(resolved_flag) * 100.0 / SUM(answered_flag), 1)   AS resolution_rate_pct,
    ROUND(AVG(satisfaction_rating), 2)                          AS avg_satisfaction,
    ROUND(AVG(avg_talk_duration_sec), 1)                        AS avg_talk_duration_sec
FROM calls
GROUP BY agent
ORDER BY resolution_rate_pct DESC;

-- INSIGHT (Query 4):
-- Agent performance is consistent across the team:
--   - Resolution rate spread: 1.7 points (Greg 90.6% top, Stewart 88.9% bottom)
--   - Satisfaction spread:    0.10 points (Martha 3.47 top, Becky 3.37 bottom)
--
-- HIDDEN PATTERN — Productivity vs. Quality tradeoff:
-- Becky has the highest answer rate (81.9%) but the lowest satisfaction (3.37).
-- Martha answers fewer calls but has the highest satisfaction (3.47).
-- This suggests two operational profiles within the team:
--   - High-throughput (Becky, Greg, Jim) — fast, slightly lower satisfaction
--   - High-quality (Martha, Dan)         — slower, higher satisfaction
-- Recommendation: cross-coaching could lift the throughput agents' 
-- satisfaction scores without sacrificing speed.

-- ---------------------------------------------------------------------
-- Query 5: Per-topic agent ranking using CTE + Window Function
-- Identifies the BEST and WORST agent for each topic based on 
-- satisfaction. Uses a CTE for readability and RANK() to rank within 
-- each topic group.
-- ---------------------------------------------------------------------

WITH agent_topic_stats AS (
    SELECT
        topic,
        agent,
        COUNT(*)                                AS calls_handled,
        ROUND(AVG(satisfaction_rating), 2)      AS avg_satisfaction
    FROM calls
    WHERE answered_flag = 1   -- only calls that actually happened
    GROUP BY topic, agent
),
ranked AS (
    SELECT
        topic,
        agent,
        calls_handled,
        avg_satisfaction,
        RANK() OVER (PARTITION BY topic ORDER BY avg_satisfaction DESC) AS rank_best,
        RANK() OVER (PARTITION BY topic ORDER BY avg_satisfaction ASC)  AS rank_worst
    FROM agent_topic_stats
)
SELECT 
    topic,
    agent,
    calls_handled,
    avg_satisfaction,
    CASE 
        WHEN rank_best = 1  THEN '⭐ Best for topic'
        WHEN rank_worst = 1 THEN '⚠ Needs coaching'
        ELSE ''
    END AS label
FROM ranked
WHERE rank_best = 1 OR rank_worst = 1
ORDER BY topic, rank_best;
-- INSIGHT (Query 5):
-- Agent specialisation by topic — a pattern hidden by aggregation:
--   * Dan    — Best for Technical Support (3.60) and Admin Support (3.51)
--                BUT worst for Contract related (3.26)
--   * Diane  — Best for Contract (3.49) and Payment (3.51)
--                BUT worst for Admin Support (3.33)
--   * Martha — Best for Streaming (3.59)
--   * Joe    — Worst for Streaming (3.22) and Technical Support (3.29)
--
-- KEY METHODOLOGICAL FINDING:
-- When agents were viewed in aggregate (Query 4), satisfaction spread
-- was just 0.10 points — performance looked flat. But when sliced 
-- agent × topic, the spread widens to 0.34 points. Aggregation hid
-- the real variation.
--
-- RECOMMENDATION:
-- Implement skills-based call routing — direct each topic to its 
-- top-performing agents. This could lift overall satisfaction without
-- adding headcount or changing training, simply by better matching
-- existing strengths to incoming calls. 