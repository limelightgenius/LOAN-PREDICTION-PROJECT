# LOAN-DEFAULT-PREDICTION-PROJECT

Finance Analytics Portfolio Project

**Tools:** Excel · MySQL · Python (Pandas, Matplotlib, Seaborn) · Power BI

| Metric | Value |
|---|---|
| Applications Analysed | 614 |
| Overall Approval Rate | 69% |
| Average Loan Amount | $146,000 |
| High Risk Applications | 97 |

---

## 1. The Business Problem

A bank's lending division approved 614 loan applications last quarter,
but a significant portion defaulted — costing an estimated $50,000 per
default. Loan officers were making decisions based on gut feeling and
basic checks rather than data.

The Head of Lending framed the challenge in four questions:

- What factors predict successful repayment?
- What is the profile of a safe borrower?
- Can we create a risk scoring system?
- Should we change our approval criteria?

The financial motivation was clear - a data-driven approval process
could prevent an estimated $750,000 in annual losses.

---

## 2. The Dataset

**Source:** Loan Prediction Problem Dataset via Kaggle  https://www.kaggle.com/datasets/architsharma01/loan-approval-prediction-dataset
**Size:** 614 applications, 13 columns
---

## 3. My Approach

**Raw CSV → Excel → MySQL → Python → Power BI**

I never modified the original file. Every stage produced a cleaner 
version that fed into the next.

---

### Step 1 - Excel: Initial Cleaning
<img width="661" height="380" alt="EXCEL DASHBOARD" src="https://github.com/user-attachments/assets/710209e5-d21e-4f28-a92f-1dd53596f3ed" />

- Removed duplicate rows
- Handled missing values across 7 columns:
  - Gender, Married, Dependents, Self_Employed → filled with mode
  - LoanAmount → filled with median (128) due to right skew
  - Loan_Amount_Term → filled with mode (360 months)
  - Credit_History → filled with 0 (unknown = no history -
    conservative banking decision)
- Replaced `3+` in Dependents with `3` - was causing 51 rows to 
  be dropped on MySQL import
- Multiplied LoanAmount by 1,000 to reflect true dollar values
- Saved as new file - raw CSV untouched

---

### Step 2 - MySQL: Deep Cleaning and Business Analysis

**Overall Approval Rate**
```sql
SELECT COUNT(*) AS Total_Applications,
    SUM(CASE WHEN Loan_Status = 'YES' THEN 1 ELSE 0 END) AS Accepted,
    SUM(CASE WHEN Loan_Status = 'No' THEN 1 ELSE 0 END) AS Rejected,
    ROUND(SUM(CASE WHEN Loan_Status = 'YES' THEN 1 ELSE 0 END) 
        * 100 / COUNT(*), 2) AS Approval_rate_percent
FROM Loan_dataset;
```

**Approval by Education, Gender, Property Area**
```sql
SELECT Education,
    COUNT(*) AS Total_Applications,
    SUM(CASE WHEN Loan_status = 'YES' THEN 1 ELSE 0 END) AS Approved,
    ROUND(SUM(CASE WHEN Loan_status = 'Yes' THEN 1 ELSE 0 END) 
        * 100.0 / COUNT(*), 2) AS Approval_rate_percent
FROM Loan_dataset
GROUP BY Education;
```

**Average Household Income by Approval Status**
```sql
SELECT Loan_Status,
    ROUND(AVG(Total_household_income), 2) AS Average_Income
FROM Loan_dataset
GROUP BY Loan_Status;
```

**Debt-to-Income Ratio**
```sql
-- Average by approval status
SELECT Loan_Status,
    ROUND(AVG(Loan_Amount / Total_household_income), 2) 
        AS Average_debt_to_income_ratio
FROM Loan_dataset
GROUP BY Loan_Status;

-- Per customer
SELECT Loan_Status,
    ROUND(Loan_Amount / Total_household_income, 2) 
        AS Debt_to_income_ratio_per_customer
FROM Loan_dataset;
```

**Approval Recommendation Model**
```sql
SELECT COUNT(*) AS Total_Applications,
    SUM(CASE WHEN Credit_History = '1' THEN 1 ELSE 0 END) AS Approve,
    SUM(CASE WHEN Credit_History = '0' 
        AND Total_household_income >= 8000 THEN 1 ELSE 0 END) AS Review,
    SUM(CASE WHEN Credit_History = '0' 
        AND Total_household_income < 8000 THEN 1 ELSE 0 END) AS Reject
FROM Loan_dataset;
```

---

### Step 3 — Python: Exploratory Analysis and Visualisations

**Feature Engineering**
```python
# Total household income
df['Total_household_income'] = (df['Applicant_Income'] 
                                + df['Coapplicant_Income'])

# Debt-to-income ratio
df['Debt_to_income_ratio'] = (df['Loan_Amount'] 
                              / df['Total_household_income']).round(2)

# Approval recommendation
df['Recommendation'] = 'Reject'
df.loc[df['Credit_History'] == 1, 'Recommendation'] = 'Approve'
df.loc[(df['Credit_History'] == 0) 
    & (df['Total_household_income'] >= 8000), 
    'Recommendation'] = 'Review'
```

**Statistical Analysis**
```python
corr = df[['Total_household_income', 'Loan_Amount', 
           'Debt_to_income_ratio', 'Credit_History']].corr()
print(corr)
```
<img width="1000" height="600" alt="Correllation_heatmap" src="https://github.com/user-attachments/assets/36b76958-860c-4ec6-8782-be45144b33a6" />

---

**Visualisations**

**Approval Rate by Credit History**
<img width="640" height="480" alt="Approval_by_credit_history" src="https://github.com/user-attachments/assets/3e22ed48-0226-4157-b1fb-deb0090818ed" />

**Distribution of Loan Amounts**
<img width="1000" height="600" alt="Distribution_of_loan_Amount" src="https://github.com/user-attachments/assets/8d2baf49-4a29-414e-9bcd-cb3078bfd39a" />

**Distribution of Total Household Income**

<img width="1500" height="600" alt="Distribution_of_household_income" src="https://github.com/user-attachments/assets/97f149c4-6e65-4e0a-adbb-7e26bf81d748" />

**Loan Amount vs Total Household Income**

<img width="1000" height="600" alt="loan_Amount_VS_total_income" src="https://github.com/user-attachments/assets/deb9f887-c65c-4dc2-920d-37daa1a8a50b" />

**Correlation Heatmap**
<img width="1000" height="600" alt="Correllation_heatmap" src="https://github.com/user-attachments/assets/bea483e4-8150-454e-a8b9-62cdd445ae93" />


**Loan Approval Recommendations**
<img width="500" height="300" alt="Loan Approval Recommnedation" src="https://github.com/user-attachments/assets/a5b5f8c9-eab3-4ef3-8b9d-8ac7cdc2c505" />

---

### Step 4 — Power BI: Interactive Dashboard
<img width="773" height="430" alt="FINANCE 3 DASHBOARD" src="https://github.com/user-attachments/assets/aea72057-3b27-4f66-822a-91a456e730a5" />

- KPI cards: overall approval rate, total applications, 
  average loan amount, high risk count
- Approval recommendations donut chart
- Approval by education and credit history bar charts
- Approval rate by property area bar chart
- Income vs loan amount scatter plot coloured by loan status
- Slicers: credit history, gender, education, 
  property area, income range

---

## 4. Key Findings

### Finding 1 - Credit history is the single biggest approval driver

Applicants with credit history were approved at **80%**. 
Those without were approved at only **32%**. No other variable 
came close to this gap.


### Finding 2 - Education affects approval but less than expected

Graduate applicants were approved at **71%** versus **61%** for 
non-graduates. The gap exists but is modest.

### Finding 3 - Location matters

Semiurban applicants had the highest approval rate at **77%**, 
followed by Urban at **66%** and Rural at **61%**.

### Finding 4 - Debt burden is a clearer risk signal than income alone

Approved applicants consistently carried a lower debt-to-income ratio 
than rejected ones. Affordability relative to loan size matters more 
than raw income.

### Finding 5 - Correlation analysis confirms the patterns statistically

| Variable Pair | Correlation | What It Means |
|---|---|---|
| Total_Income vs Loan_Amount | 0.62 | Higher earners borrow more |
| Total_Income vs DTI_Ratio | -0.39 | Higher income reduces debt burden |
| Credit_History vs all | ~0.00 | Operates independently — pure behavioural signal |


### Finding 6 - Approval recommendation model

| Recommendation | Criteria | Count |
|---|---|---|
| Approve | Credit History = 1 | 475 (77.4%) |
| Reject | Credit History = 0, Income < £8,000 | 114 (18.6%) |
| Review | Credit History = 0, Income >= £8,000 | 25 (4.1%) |

---

## 5. Business Recommendations

**1. Make credit history the primary approval gate**  
The data is unambiguous. Formalise credit history as the first 
checkpoint in every application review.

**2. Introduce a structured review process for borderline cases**  
Applicants with no credit history but household income above £8,000 
should not be automatically rejected. A manual review with additional 
documentation could recover safe loans.

**3. Investigate the rural approval gap**  
Rural applicants are approved at 61% versus 77% for semiurban. Before 
treating this as a risk signal, investigate whether this reflects 
genuine default risk or bias in the current process.

**4. Replace income checks with DTI ratio assessments**  
Raw income is a weak predictor. A £50,000 salary means little if the 
applicant is borrowing £45,000.

**5. Use the risk model to prioritise manual reviews**  
The 25 Review-flagged applicants represent recoverable revenue. 
A 30-minute manual review per case could recover significant interest 
income that would otherwise be declined.

---

## 6. Tools and Skills

| Tool | How I Used It | Key Techniques |
|---|---|---|
| Excel | Initial cleaning | Missing value imputation, duplicate removal |
| MySQL | Business queries | AVG, GROUP BY, CASE WHEN, calculated columns |
| Python (Pandas) | Feature engineering | Calculated columns, correlation matrix, np.where |
| Python (Matplotlib/Seaborn) | Visualisations | Histograms, scatter plots, heatmaps, pie charts |
| Power BI | Interactive dashboard | DAX measures, slicers, KPI cards |
| GitHub | Documentation | README, project folder structure |

---

## 7. Conclusion

Credit history is the dominant predictor. Debt-to-income ratio is more 
useful than raw income. Location signals exist but require further 
investigation. A structured three-tier approval model - Approve, 
Review, Reject - gives loan officers a data-driven framework to replace 
gut-feeling decisions.

Based on the numbers in this analysis, implementing these criteria 
could realistically prevent a significant portion of the estimated 
$750,000 in annual default losses while ensuring safe applicants are 
not unfairly rejected.

*This project is part of my data analytics portfolio, built end-to-end 
to demonstrate real-world problem solving from raw data to business 
recommendations.*
