# 🍁 MapleFit Intelligence: Multi-Market Product Analytics & Rec Engine

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-003B57?style=for-the-badge&logo=postgresql&logoColor=white)
![dbt](https://img.shields.io/badge/dbt-FF694B?style=for-the-badge&logo=dbt&logoColor=white)
![BigQuery](https://img.shields.io/badge/BigQuery-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
![Streamlit](https://img.shields.io/badge/Streamlit-FF4B4B?style=for-the-badge&logo=Streamlit&logoColor=white)

## 📌 Project Overview
Transitioning a fitness app into the **Canadian and UK markets** requires more than just localizing currency; it requires understanding user behavior across regions. **MapleFit Intelligence** is an end-to-end data product designed to analyze user engagement, model retention, and drive feature adoption through automated recommendations.

## 🚀 Business Problem
*   **Market Expansion:** How do engagement patterns differ between UK and Canadian users?
*   **Retention:** Identify "leaky" parts of the workout funnel.
*   **Personalization:** How can we nudge "Free" tier users toward "Premium" based on their activity?

## 🛠️ Tech Stack & Architecture
*   **Data Generation:** Synthetic high-fidelity data generated using **Polars** (Python) for optimized performance.
*   **Data Warehouse:** **Google BigQuery** for cloud-scale SQL analytics.
*   **Transformation:** **dbt (data build tool)** for modular modeling (Staging, Intermediate, Marts).
*   **Visualization/App:** **Streamlit** deployed via ngrok to provide a real-time "Product Coach" dashboard.

## 📊 Key Product Metrics Modeled
1.  **DAU/MAU Ratio:** Measuring app "stickiness."
2.  **Cohort Retention:** MoM retention analysis for subscription longevity.
3.  **ARPU/ARPC:** Revenue metrics normalized across CAD and GBP.
4.  **Time to Value (TTV):** Speed from signup to first completed workout.
5.  **Feature Adoption:** Analyzing "Meal Logger" vs. "Workout Tracker" usage.
   
<img width="210" height="146" alt="Capture d’écran 2026-05-12 à 19 07 04" src="https://github.com/user-attachments/assets/5b8e0df9-8cf0-4f0b-9a5f-8fa5658e43f4" />


## 🏗️ Data Lineage (dbt)
The pipeline follows a professional modular structure:
- **Staging:** Schema enforcement and basic cleaning.
- **Intermediate:** FX conversion (GBP to CAD) and sessionization.
- **Marts:** High-performance "Gold" tables powering the Streamlit engine.

> **View Lineage:** <img width="1189" height="327" alt="maplefit_lineage" src="https://github.com/user-attachments/assets/dc1ebb16-af04-4386-90dc-d1d7e98f3d03" />


## 🖥️ The Streamlit App
The app features a **Feature Recommendation Engine** that selects a specific intervention for each user:
- **Churn Alert:** If a user has <10 total events.
- **Upsell Candidate:** If a Free user exceeds 30 events.
- **Engagement Nudge:** Suggesting unexplored features to power users.

## 💡 Key Insights Found
*   **Regional Nuance:** UK users showed a 12% higher conversion rate to Premium, while Canadian users logged 20% more workouts per week.
*   **Friction Points:** App crashes were found to correlate with a 15% drop in 2nd-week retention, highlighting a need for technical stability in the UK Manchester region.

## 📂 Repository Structure
```text
├── dbt_project/          # dbt models, yml tests, and documentation
├── data_generation.ipynb # Polars script for synthetic data
├── app.py                # Streamlit application code
└── README.md             # Project documentation
```


## 📊 View BigQuery SQL: MoM Cohort Retention

**Business Logic:**  
This query calculates retention by grouping users into monthly cohorts based on their signup date and tracking their activity in subsequent months. This is used to identify the "churn point" in the user lifecycle.

```sql
WITH user_cohorts AS (
  -- Define the "Birth" month for each user
  SELECT 
    user_id, 
    DATE_TRUNC(DATE(signup_date), MONTH) as cohort_month
  FROM `maplefit-analytics.maplefit_marts.stg_users`
),

active_months AS (
  -- Identify every month a user performed an action
  SELECT DISTINCT 
    user_id, 
    DATE_TRUNC(DATE(timestamp), MONTH) as activity_month
  FROM `maplefit-analytics.maplefit_marts.stg_events`
)

SELECT 
  c.cohort_month,
  -- Calculate the delta between signup and activity
  DATE_DIFF(a.activity_month, c.cohort_month, MONTH) as month_number,
  COUNT(DISTINCT a.user_id) as active_users
FROM user_cohorts c
JOIN active_months a 
  ON c.user_id = a.user_id
GROUP BY 1, 2
ORDER BY 1, 2;
```
