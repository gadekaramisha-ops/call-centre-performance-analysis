# 📞 Call Centre Performance Analysis
### Operations & Resource Optimization — an end-to-end data analytics project

> Turning **5,000 raw call records** into **three evidence-based recommendations** — using Python, MySQL, and Power BI.

![Python](https://img.shields.io/badge/Python-Data%20Prep-D04A02)
![MySQL](https://img.shields.io/badge/MySQL-Analysis-EB8C00)
![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-FFB600)
![Status](https://img.shields.io/badge/Status-Complete-2D7A4A)

---

## 📋 Overview

This project analyses **Q1 2021 call centre operations** to understand why nearly one in five calls went unanswered — and what the business can do about it. It demonstrates a complete analytics workflow: cleaning and preparing raw data in **Python**, querying KPIs in **MySQL**, and building an interactive two-page dashboard in **Power BI**, before packaging the findings into an executive presentation.

The headline question driving the analysis:

> **19% of calls went unanswered. Why — and where should the business focus to fix it?**

---

## 🎯 Key Findings

| Metric | Result | What it tells us |
|--------|--------|------------------|
| **Total Calls** | 5,000 | Q1 2021 (Jan–Mar) |
| **Answer Rate** | 81% | ~1 in 5 calls never answered |
| **Resolution Rate** | 89.94% | Strong — *once* a call is answered |
| **Avg Satisfaction** | 3.40 / 5 | Consistent across the board |
| **Avg Speed of Answer** | 67.5 sec | ~1 min average wait (answered calls only) |

**The core insight:** The team resolves nearly **9 in 10** calls it answers — but answers only **4 in 5**. Quality isn't the problem; **capacity** is. The 946 unanswered calls (19%) are spread evenly across every hour and every topic, which points to a **systemic baseline-capacity shortfall**, not a peak-hour or single-topic bottleneck.

**A hidden pattern:** While agent resolution rates sit within a tight 1.7-point band (88.9%–90.6%) — suggesting agents are interchangeable — topic-level satisfaction tells a different story. Clear specialists emerge: for example, **Dan leads Technical Support (3.60)** but lags on Contract-related calls (3.26). This specialisation is invisible in aggregate metrics and is a lever for smarter call routing.

---

## 💡 Recommendations

1. **Increase baseline capacity** — Add front-line headcount or flex scheduling to lift the answer rate. Because the shortfall is steady all day, a consistent capacity increase (not peak-only staffing) is the fix. *Addresses the 19% unanswered gap.*

2. **Skills-based call routing** — Route calls to agents who score highest on that topic (e.g. Technical Support → Dan, Contract → Diane). Lifts satisfaction using existing staff strengths, **at zero added headcount**. *Addresses hidden specialisation.*

3. **Targeted topic coaching** — Pair each agent's strongest topic with their weakest for peer coaching, narrowing the satisfaction spread over time. *Addresses per-agent blind spots.*

---

## 🛠️ Tools & Tech Stack

| Stage | Tool | What it did |
|-------|------|-------------|
| **1. Data Prep** | Python (pandas, numpy) | Cleaning, type conversion, feature engineering |
| **2. Analysis** | MySQL | KPI queries, CTEs, window functions |
| **3. Visualisation** | Power BI (DAX) | Interactive 2-page dashboard |
| **4. Reporting** | PowerPoint | Executive presentation |

---

## 📁 Project Structure

```
call-centre-performance-analysis/
│
├── data/                # Raw + cleaned datasets, exported chart
│   ├── Call_Center_Data.csv
│   ├── call_center_cleaned.csv
│   └── agent_resolution_leaderboard.png
│
├── notebooks/           # Python data cleaning & EDA
│   └── 01_data_cleaning.ipynb
│
├── sql/                 # SQL analysis queries
│   └── 01_basic_kpis.sql
│
├── powerbi/             # Interactive dashboard
│   └── Call_Centre_Dashboard.pbix
│
├── report/              # Executive presentation
│   ├── Call_Centre_Report.pptx
│   └── Call_Centre_Report.pdf
│
└── README.md            # You are here
```

---

## 🔍 Methodology

**1 · Python — Data Preparation**
Loaded the raw Excel dataset, converted data types (dates, call duration `HH:MM:SS` → seconds), engineered features (`call_hour`, `day_of_week`, `answered_flag`, `resolved_flag`), and preserved the 946 unanswered calls as `NULL` rather than imputing them. Built an agent-resolution leaderboard chart.

**2 · MySQL — Analysis**
Loaded the cleaned data into a MySQL database and wrote five portfolio queries: overall KPIs, hourly volume & answer rate, topic breakdown, an agent leaderboard, and an agent × topic specialisation query using a **CTE + `RANK()` window function** to surface hidden specialists.

**3 · Power BI — Visualisation**
Built a two-page interactive dashboard with custom **DAX measures** (Answer Rate %, Resolution Rate %), KPI cards, combo charts, an interactive agent slicer, and a conditional-formatting heatmap. All KPIs were **cross-validated** against the Python and SQL outputs.

**4 · PowerPoint — Reporting**
Packaged the analysis into an eight-slide executive presentation using action-driven titles and evidence-linked recommendations.

---

## 📊 Dashboard Preview

> _Add your dashboard screenshots here once uploaded — replace the lines below with the image paths._

<!-- Example:
![Executive Overview](data/dashboard_page1.png)
![Agent Performance](data/dashboard_page2.png)
-->

**Page 1 — Executive Overview:** Headline KPIs, call volume by hour and topic, agent resolution leaderboard, and a key-insight callout.

**Page 2 — Agent Performance:** Interactive agent slicer, per-agent KPI cards, a resolution-vs-satisfaction combo chart, and an agent × topic satisfaction heatmap.

---

## 📑 Dataset

**PwC Call Centre Trends Dataset** (publicly available) — 5,000 calls, 8 agents, 5 call topics, January–March 2021. Fields include call ID, agent, date/time, topic, answered (Y/N), resolved, speed of answer, talk duration, and satisfaction rating.

---

## 👤 About the Analyst

**Amisha Gadekar** — Aspiring Business Analyst

This project demonstrates an end-to-end analytics workflow — from raw data to decision-ready insight — combining technical skills (Python, SQL, Power BI, DAX) with business storytelling.

📧 gadekaramisha@gmail.com  
🔗 [LinkedIn](https://www.linkedin.com/in/AmishaGadekar) · [GitHub](https://github.com/gadekaramisha-ops)

---

<sub>Data source: PwC Call Centre Trends Dataset · Built with Python, MySQL & Power BI · 2026</sub>
