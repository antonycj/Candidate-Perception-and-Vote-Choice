# 🗳️ Vote Choice and Candidate Characteristics (ANES 2016–2024)

This project investigates how **voters’ perceptions of presidential candidates’ personal characteristics** — such as honesty, competence, empathy, and leadership — influence **vote choice** across the **2016, 2020, and 2024 U.S. elections**.  

Data come from the **American National Election Studies (ANES)** time-series datasets, analyzed in **R** using logistic regression, predicted probabilities, and visualization techniques.

---

## 🧠 Research Overview
Voter evaluations of candidates’ personalities often shape electoral outcomes beyond party identification and ideology.  
This study compares how personal trait perceptions have predicted vote choice across three election cycles, testing whether the strength and direction of these effects have changed over time.

---

## 🧰 Methods & Tools
- **R** – Statistical modeling and visualization  
  - Packages: `tidyverse`, `ggplot2`, `dplyr`, `broom`, `margins`
- **Models:** Logistic regressions predicting vote choice as a function of perceived personal characteristics  
- **Visualizations:** Forest plots, histograms, and predicted probability plots  
- **Data:** American National Election Studies (ANES) 2016, 2020, 2024

---

---

## 📊 Results by Year

### 🗓️ 2016 Election
| File | Description |
|------|--------------|
| [2016 ANES capstone.R](https://github.com/antonycj/your-repo-name/blob/main/2016%20ANES%20capstone.R) | R script for data cleaning, modeling, and visualization (2016 ANES). |
| [model1_2016_table.docx](https://github.com/antonycj/your-repo-name/blob/main/model1_2016_table.docx) | Logistic regression results for 2016. |
| [ANES_histograms.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_histograms.docx) | Trait distribution histograms. |
| [ANES_ideology.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_ideology.docx) | Ideological placement analysis. |
| [ANES_pid.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_pid.docx) | Party identification distributions. |
| [forest_plot.docx](https://github.com/antonycj/your-repo-name/blob/main/forest_plot.docx) | Visualizes effect sizes for trait predictors of vote choice. |

---

### 🗓️ 2020 Election
| File | Description |
|------|--------------|
| [2020 Anes Capstone.R](https://github.com/antonycj/your-repo-name/blob/main/2020%20Anes%20Capstone.R) | R script for 2020 ANES logistic regression and visualization. |
| [model1_2020_table.docx](https://github.com/antonycj/your-repo-name/blob/main/model1_2020_table.docx) | Regression output for 2020. |
| [ANES_2020_histograms.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_2020_histograms.docx) | Visualizing 2020 trait distributions. |
| [ANES_2020_ideology.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_2020_ideology.docx) | Ideological positioning of 2020 respondents. |
| [predicted_probabilities.png](https://github.com/antonycj/your-repo-name/blob/main/predicted_probabilities.png) | Predicted probability plots for candidate evaluation effects (2020). |

---

### 🗓️ 2024 Election
| File | Description |
|------|--------------|
| [ANES 2024 capstone.R](https://github.com/antonycj/your-repo-name/blob/main/ANES%202024%20capstone.R) | R script for 2024 ANES analysis and visualization. |
| [model1_2024_table.docx](https://github.com/antonycj/your-repo-name/blob/main/model1_2024_table.docx) | Logistic regression output for 2024. |
| [ANES_2024_histograms.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_2024_histograms.docx) | Trait distributions for 2024 respondents. |
| [ANES_2024_ideology.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_2024_ideology.docx) | Ideology metrics for 2024 respondents. |
| [ANES_2024_pid.docx](https://github.com/antonycj/your-repo-name/blob/main/ANES_2024_pid.docx) | Party identification and polarization. |
| [predicted_probabilities_2024.png](https://github.com/antonycj/your-repo-name/blob/main/predicted_probabilities_2024.png) | Visualization of predicted probabilities for candidate trait evaluations (2024). |
| [forest_plot_2024.docx](https://github.com/antonycj/your-repo-name/blob/main/forest_plot_2024.docx) | Visual summary of 2024 regression effect sizes. |

---
## 📈 Findings

Across all three election years — **2016, 2020, and 2024** — perceptions of **candidates’ personal characteristics** had a measurable and consistent influence on how Americans voted.  

### 🗳️ Key Results
- **Leadership and honesty** remained the strongest predictors of vote choice in every cycle.  
- In **2016**, evaluations of **honesty and empathy** were sharply polarized between Trump and Clinton voters, reflecting the centrality of trust and temperament in that election.  
- In **2020**, traits related to **competence and empathy** grew in importance, particularly in the context of the COVID-19 pandemic.  
- By **2024**, the data indicate increasing **ideological sorting**, with voters’ evaluations of candidate traits aligning more tightly with **partisanship and ideology**.  
- Positive trait perceptions substantially increased the **predicted probability** of voting for a candidate — even when controlling for ideology and party ID.

### 🔍 Patterns Over Time
- The strength of personality-based predictors of vote choice **has not declined**, but their **association with partisanship** has intensified.  
- Trait evaluations that once reflected cross-party appeal (e.g., competence, empathy) now **track more closely with partisan identity**.  
- Visualizations from predicted probability models and forest plots show **widening partisan gaps** in how voters interpret the same candidate characteristics.

### 💬 Interpretation
These results suggest that **personal evaluations have become a partisan lens**, not an independent heuristic.  
While voters still claim to value character and leadership, those judgments now largely **mirror partisan loyalties**, reinforcing polarization rather than moderating it.

---

📄 For full regression results, model tables, and visualization outputs, see:  
- [Predicted Probabilities (2024)](https://github.com/antonycj/your-repo-name/blob/main/predicted_probabilities_2024.png)  
- [Forest Plots (2020–2024)](https://github.com/antonycj/your-repo-name/blob/main/forest_plot_2024.docx)  
- [Full Report (PDF)](https://github.com/antonycj/your-repo-name/blob/main/ANES_Candidate_Characteristics_Report.pdf)

---

## 📬 Contact
**David Jackson**  
📧 [Adavidj59@gmail.com](mailto:Adavidj59@gmail.com)
