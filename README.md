<p align="center">
  <img width="180" height="53" alt="LOGO" src="https://github.com/user-attachments/assets/63ffa2d7-5b57-4c9a-b899-cf381f62bd14">
</p>

<h1 align="center">Insurance Risk & Claims Analytics Dashboard</h1>

<p align="center">
An End-to-End Insurance Analytics Project using <b>Excel • Python • MySQL • Power BI</b>
</p>

<p align="center">

![Python](https://img.shields.io/badge/Python-3.11-blue?style=for-the-badge&logo=python)
![MySQL](https://img.shields.io/badge/MySQL-Database-orange?style=for-the-badge&logo=mysql)
![Power BI](https://img.shields.io/badge/Power_BI-Dashboard-yellow?style=for-the-badge&logo=powerbi)
![Pandas](https://img.shields.io/badge/Pandas-Data_Analysis-purple?style=for-the-badge&logo=pandas)

</p>

---

# 📌 Project Overview

Insurance companies manage thousands of policies, customers, claims, agents, and feedback records every year. Monitoring profitability, identifying fraudulent claims, understanding customer risk, and improving underwriting decisions require an integrated analytics solution.

This project builds a complete Business Intelligence solution that transforms raw insurance data into actionable insights using SQL, Python, and Power BI.

The solution was designed as a real-world analytics project for Insurance Company, covering the complete analytics lifecycle from business understanding to strategic recommendations.

---

# 🎯 Business Problem

The company faced several analytical challenges:

- High claim payouts reducing profitability
- Increasing fraud exposure
- Lack of centralized executive dashboards
- Difficulty identifying high-risk customers
- Regional profitability differences
- Limited visibility into agent productivity
- Need for predictive claim forecasting

---

# 🛠 Tech Stack

| Tool | Purpose |
|------|----------|
| Excel | Raw Data Validation |
| Python | Data Cleaning & Feature Engineering |
| Pandas | Data Manipulation |
| NumPy | Numerical Analysis |
| Matplotlib | Visualization |
| SciPy | Statistical Testing |
| MySQL | Database & SQL Analysis |
| Power BI | Dashboard Development |
| DAX | KPI Calculations |

---

# 📂 Analytics Workflow

```
Raw Excel Files
        │
        ▼
MySQL Database
        │
        ▼
SQL Business Analysis
        │
        ▼
Python Data Cleaning
        │
        ▼
Feature Engineering
        │
        ▼
EDA & Statistical Testing
        │
        ▼
Forecasting
        │
        ▼
Export Clean Data
        │
        ▼
Power BI Dashboard
        │
        ▼
Business Insights
```

---

# 📊 Dataset Overview

The project contains five interconnected datasets.

| Dataset | Records |
|----------|---------|
| Customer Master | 1,648 |
| Policy Details | 2,828 |
| Claim History | 1,407 |
| Agent Information | 300 |
| Customer Feedback | 631 |

---

# Data Quality Process

The data validation process included:

- Duplicate detection
- Missing value treatment
- Foreign key validation
- Invalid value correction
- Date validation
- Data type correction
- Business rule validation
- Row count verification

---

# Feature Engineering

Several business features were created including:

- Premium Collected
- Policy Duration
- Loss Ratio
- Customer Risk Segment
- Customer Age Group
- Fraud Ratio
- Agent Productivity
- Premium per Agent
- Claim Frequency
- Forecast Variance

---

# Statistical Analysis

Business assumptions were validated using statistical tests.

| Test | Business Question |
|------|-------------------|
| Independent T-Test | Smokers vs Non-Smokers Claim Amount |
| One-Way ANOVA | Regional Claim Difference |
| One-Way ANOVA | Policy Type Claim Difference |
| One-Way ANOVA | Age Group Claim Difference |
| Chi-Square Test | Claim Status vs Claim Type |
| Pearson Correlation | Risk Score vs Claim Amount |

---

# SQL Analysis

Business KPIs calculated using MySQL include:

- Total Premium Collected
- Total Claims Paid
- Loss Ratio
- Fraud Ratio
- Claim Approval Rate
- Regional Performance
- Product Performance
- Agent Performance
- Customer Risk Analysis
- Trend Analysis

---

# 📈 Power BI Dashboard

The dashboard contains seven interactive pages.

### 🏠 Home

Project navigation

---

### 📊 Executive Overview

- Premium Collected
- Claims Paid
- Loss Ratio
- Fraud Ratio
- Premium vs Claims Trend
- Product Distribution
- Customer Risk Distribution

---

### 🚨 Claims & Fraud Analysis

- Claims by Product
- Claims by Region
- Fraud Rate
- Claim Status
- Fraud Cases

---

### 👥 Customer Risk Analysis

- Risk Segmentation
- Claims by Age Group
- Smoking Analysis
- Pre-existing Conditions
- High Risk Customers

---

### 🌍 Regional Performance

- Premium Collection
- Claims Paid
- Loss Ratio
- Fraud Rate
- Regional Comparison

---

### 👨‍💼 Agent Performance

- Premium Sold
- Policies Sold
- Agent Fraud Ratio
- Regional Performance
- Top Performing Agents

---

### 📉 Forecasting

- Monthly Claim Forecast
- Forecast Accuracy
- Forecast Variance
- Actual vs Forecast Comparison

---

# Dashboard Preview

## Home

<img width="1547" height="863" alt="Home" src="https://github.com/user-attachments/assets/ee4d692d-660e-4334-85a3-9e19fca6596b" />


---

## Executive Overview

<img width="1530" height="862" alt="Executive_Overview" src="https://github.com/user-attachments/assets/0dad2c30-9e39-4149-98ce-94b358a43112" />


---

## Claims & Fraud

<img width="1541" height="863" alt="Claims_Fraud" src="https://github.com/user-attachments/assets/f2b6c918-0ca7-4fab-af93-88c0dcb04626" />


---

## Customer Risk

<img width="1540" height="863" alt="Customer_Risk" src="https://github.com/user-attachments/assets/00af00bf-3985-4985-85a9-728c306eeda8" />


---

## Regional Analysis

<img width="1540" height="862" alt="Regional_Analysis" src="https://github.com/user-attachments/assets/03ccab78-0ed1-4c08-b32d-4f65a892cf5b" />


---

## Agent Performance

<img width="1542" height="865" alt="Agent_Performance" src="https://github.com/user-attachments/assets/05f8b4ab-179e-4ff7-80f9-8625b2bc3e18" />


---

## Forecasting

<img width="1545" height="863" alt="Forecasting" src="https://github.com/user-attachments/assets/89d24211-eaac-4423-a93e-a7bf84f51439" />


---

# 💡 Key Business Insights

- Premium Collected: **₹97.39 Million**
- Claims Paid: **₹127.39 Million**
- Portfolio Loss Ratio: **130.80%**
- Fraud Ratio: **48.97%**
- Health insurance generated the highest claim payouts.
- South region recorded the highest loss ratio.
- North region showed the highest fraud exposure.
- Moderate-risk customers formed the largest customer segment.
- Forecasting indicates claim volumes are expected to stabilize in future periods.

---

# Strategic Recommendations

- Strengthen underwriting for high-claim insurance products.
- Deploy fraud detection models in high-risk regions.
- Implement risk-based premium pricing.
- Improve agent performance through targeted training.
- Use forecasting for reserve planning.
- Focus customer acquisition on low-risk segments.

---

# 📁 Repository Structure

```
Insurance-Risk-and-Claims-Analytics/
│
├── Data/
│   │
│   ├── Raw_Data/
│   │   ├── agentinfo.xlsx
│   │   ├── claimhistory.xlsx
│   │   ├── customerfeedback.xlsx
│   │   ├── customermaster.xlsx
│   │   └── policydetails.xlsx
│   │
│   └── Processed_Data/
│       ├── agent_cleaned.csv
│       ├── claim_cleaned.csv
│       ├── customer_cleaned.csv
│       ├── feedback_cleaned.csv
│       ├── policy_cleaned.csv
│       ├── customer_loss.csv
│       ├── master_table.csv
│       └── claim_forecast_results.csv
│
├── SQL/
│   ├── Database_Schema.sql
│   ├── SQL_Analysis_Queries.sql
│   └── ERD_Diagram.png
│
├── Python/
│   └── Insurance_Analytics.ipynb
│
├── PowerBI/
│   └──Insurance_Analytics_Dashboard.pbix
│
├── Documentation/
│   ├── Project_Planning.pdf
│   ├── Data_Pipeline_Diagram.png
│   ├── ERD_Diagram.png
│   └── Strategic_Insights.pdf
│
├── Dashboard_Screenshots/
│   ├── Home.png
│   ├── Executive_Overview.png
│   ├── Claims_Fraud.png
│   ├── Customer_Risk.png
│   ├── Regional_Analysis.png
│   ├── Agent_Performance.png
│   └── Forecasting.png
│
├── Presentation/
|    └── Insurance_Analytics_Case_Study.pdf
│    
└── README.md
```

---

# Skills Demonstrated

- Business Understanding
- Data Validation
- Data Cleaning
- Feature Engineering
- SQL Analytics
- Database Design
- Exploratory Data Analysis
- Statistical Testing
- Forecasting
- Power BI
- DAX
- Data Storytelling
- Business Intelligence

---

# 👨‍💻 Author

### **Anuj Magre**

Data Analyst

**Skills**

SQL • Python • Power BI • Excel • Statistics • MySQL

---

⭐ If you found this project useful, don't forget to star the repository.
