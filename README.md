# 📊 Employee Engagement & Attrition Prediction  
### *Statistical & Predictive Analysis using IBM HR Analytics Dataset*

This project analyzes how **employee engagement** influences **attrition** and overall **organizational success**, using the IBM HR Analytics dataset from Kaggle.

Dataset source:  
🔗 [https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset/data](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset/data)

---

## 📁 Project Overview
Organizations often struggle with employee turnover and disengagement. This project investigates whether **engagement factors**—such as job satisfaction, work‑life balance, job involvement, and environment satisfaction—predict attrition and contribute to organizational success.

Using **statistical tests** and a **logistic regression model**, the study evaluates:

- Do engaged employees stay longer?  
- Does engagement significantly differ between those who leave vs. stay?  
- Can engagement predict attrition risk?

---

## 🎯 Objectives
- Analyze the relationship between **employee engagement** and **attrition**
- Compare engagement across **departments, job roles, and attrition groups**
- Perform **ANOVA**, **t‑test**, and **Chi‑Square** significance testing
- Build a **logistic regression model** to predict attrition probability

---

## 📊 Dataset Summary
| Feature | Value |
|--------|-------|
| Records | 1,470 |
| Features | 35 columns |
| Attrition Rate | ~16.1% (Imbalanced Class) |
| Avg Age | 41 years |
| Source | [IBM HR Analytics (Kaggle)](https://www.kaggle.com/datasets/pavansubhasht/ibm-hr-analytics-attrition-dataset/data) |

---

## 📂 Repository Structure
- `HR-Employee-Attrition.csv`: Raw employee dataset.
- `script.r`: R script for data cleaning, analysis, and modeling.
- `README.md`: Project documentation.

---

## 🛠️ Tools & Technologies
- **Language**: R (v4.5.1+)
- **Environment**: RStudio
- **Libraries**: 
  - `dplyr` (Data manipulation)
  - `ggplot2` (Data visualization)
  - `car` (Statistical testing - Levene's Test)

---

## 🚀 How to Run
1. Ensure R and the required libraries (`dplyr`, `ggplot2`, `car`) are installed.
2. Clone this repository to your local machine.
3. Place `HR-Employee-Attrition.csv` in the same directory as `script.r`.
4. Run `script.r` in RStudio or via terminal:
   ```bash
   Rscript script.r
   ```

---

## 🔧 Data Processing Steps
- Cleaned and standardized column names to lowercase.
- Verified no missing values or duplicates.
- Encoded **Attrition** as a binary numeric variable (`Yes = 1, No = 0`).
- Created a composite **Engagement Score** by calculating the mean of 5 key metrics:
  - `Job Satisfaction`
  - `Environment Satisfaction`
  - `Relationship Satisfaction`
  - `Job Involvement`
  - `Work-Life Balance`
- Categorized engagement into **Low**, **Medium**, and **High** levels based on score ranges.

---

## 📈 Descriptive Analysis
### Key Insights
- Engagement scores follow a **normal distribution**
- Employees who **left** had lower engagement (2.54)
- Employees who **stayed** had higher engagement (2.77)
- R&D department had the **highest engagement**
- HR department had the **lowest**

---

## 🧪 Inferential Statistical Tests

### 1️⃣ One‑Way ANOVA  
**Job Level → Engagement Score**  
- F = 0.776, p = 0.541  
- **No significant difference** across job levels

### 2️⃣ Independent t‑Test  
**Attrition → Engagement Score**  
- t = 7.55, p = 7.47e‑14  
- **Highly significant difference**  
- Stayed employees had **higher engagement**

### 3️⃣ Chi‑Square Test  
**Job Satisfaction × Attrition**  
- X² = 17.505, p = 0.0006  
- **Strong association**  
- Low satisfaction → 22.8% attrition  
- High satisfaction → 11.3% attrition  

---

## 🤖 Predictive Modeling — Logistic Regression

### Model Inputs
- Predictor: **Engagement Score**
- Target: **Attrition (0/1)**

### Key Results
| Metric | Value |
|--------|-------|
| Coefficient | –1.4806 (p = 3.36e‑14) |
| Odds Ratio | 0.2275 |
| Accuracy | 83.67% |
| Recall | 2.13% |
| Pseudo R² | 0.0593 |

### Interpretation
- Each 1‑unit increase in engagement reduces attrition odds by **77.25%**
- Model predicts “stayed” well but struggles with “left” due to class imbalance (Recall: 2.13%)

### Example Predictions
| Engagement Score | Probability of Leaving |
|------------------|------------------------|
| 1.0 (Low) | 69% |
| 2.5 (Mid) | 19% |
| 4.0 (High) | 3% |

---

## 💡 Conclusion & Recommendations
- **Engagement is Key**: Statistical tests confirm that higher engagement directly correlates with lower attrition. 
- **Satisfaction Matters**: Job and environment satisfaction are the strongest predictors among the engagement factors.
- **Early Intervention**: HR should focus on "Low" engagement groups (Engagement Score < 2.0) as they have a significantly higher risk of leaving.
- **Model Limitation**: While accuracy is 83.67%, it is close to the baseline. Improving recall for the minority class (those who leave) should be the priority.

---

## 📜 License
This project is licensed under the MIT License.

## 👥 Authors
- **TPSM Group 05**
  - Lihini Gunathilaka (IT23744066)
  - Manuth Jayasekara (IT23728776)
  - Osanda Madugalle (IT23555594)
  - Shazra M H (IT23693586)

---

## 🙌 Acknowledgements
Dataset provided by **IBM HR Analytics** and hosted on **Kaggle**.  
Special thanks to the open‑source R community.
