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

## 🗓️ 2016 Election

### 1️⃣ Descriptive Overview

Visualizations below summarize voter **party identification**, **ideological placement**, and **evaluations of candidate traits (valence)** among 2016 respondents from the ANES dataset.

#### Party Identification
![2016 Party ID](https://github.com/antonycj/vote-choice-anes/blob/main/images/2016_pid.png)

#### Ideology
![2016 Ideology](https://github.com/antonycj/vote-choice-anes/blob/main/images/2016_ideology.png)

#### Trait Valence
![2016 Valence](https://github.com/antonycj/vote-choice-anes/blob/main/images/2016_valence.png)

---

### 2️⃣ Statistical Findings

Regression models estimate the impact of voters’ evaluations of candidates’ personal characteristics on their probability of voting for the major party candidates.  
The models also include **demographic and policy-related control variables** (e.g., age, gender, education, income, racial identification, ideology, and issue attitudes), which are **not shown in these visualizations** but are incorporated in the full regression analyses.

#### Odds Ratios
![2016 Odds Ratios](https://github.com/antonycj/vote-choice-anes/blob/main/images/2016_odds_ratio.png)

#### Predicted Probabilities
![2016 Predicted Probabilities](https://github.com/antonycj/vote-choice-anes/blob/main/images/2016_predicted_probabilities.png)

**Findings Summary:**  
- Traits related to **honesty** and **empathy** were significant predictors of 2016 vote choice.  
- Strong partisan sorting is visible in both party ID and ideology distributions.  
- Candidate evaluations reflected sharp polarization between Trump and Clinton voters.

---

## 🗓️ 2020 Election

### 1️⃣ Descriptive Overview

Descriptive visualizations for 2020 show how voter **party identification**, **ideological self-placement**, and **trait valence** continued to polarize during a highly nationalized election.

#### Party Identification
![2020 Party ID](https://github.com/antonycj/vote-choice-anes/blob/main/images/2020_pid.png)

#### Ideology
![2020 Ideology](https://github.com/antonycj/vote-choice-anes/blob/main/images/2020_ideology.png)

#### Trait Valence
![2020 Valence](https://github.com/antonycj/vote-choice-anes/blob/main/images/2020_valence.png)

---

### 2️⃣ Statistical Findings

Regression models include **demographic characteristics** (age, gender, education, race, income) and **policy preferences** (e.g., economic and social issue scales) as controls, though these are omitted from the figures below for clarity.

#### Odds Ratios
![2020 Odds Ratios](https://github.com/antonycj/vote-choice-anes/blob/main/images/2020_odds_ratio.png)

#### Predicted Probabilities
![2020 Predicted Probabilities](https://github.com/antonycj/vote-choice-anes/blob/main/images/2020_predicted_probabilities.png)

**Findings Summary:**  
- **Competence** and **empathy** became increasingly important in 2020, reflecting issue salience during the COVID-19 pandemic.  
- Predicted probabilities show that positive candidate trait evaluations significantly increased the likelihood of voting for that candidate, even after accounting for ideology and policy preferences.  
- The ideological divide in trait perceptions widened substantially compared to 2016.

---

## 🗓️ 2024 Election

### 1️⃣ Descriptive Overview

The 2024 ANES data highlight deepened polarization in voter **party ID**, **ideological identification**, and **candidate evaluations**.  
Trait perceptions have become increasingly sorted along partisan lines.

#### Party Identification
![2024 Party ID](https://github.com/antonycj/vote-choice-anes/blob/main/images/2024_pid.png)

#### Ideology
![2024 Ideology](https://github.com/antonycj/vote-choice-anes/blob/main/images/2024_ideology.png)

#### Trait Valence
![2024 Valence](https://github.com/antonycj/vote-choice-anes/blob/main/images/2024_valence.png)

---

### 2️⃣ Statistical Findings

Regression models control for **demographic**, **ideological**, and **policy-related variables**, including age, gender, education, income, partisanship, and key issue positions.  
These variables are **not visualized below**, but they are incorporated in all model estimates to isolate the effect of candidate trait perceptions.

#### Odds Ratios
![2024 Odds Ratios](https://github.com/antonycj/vote-choice-anes/blob/main/images/2024_odds_ratio.png)

#### Predicted Probabilities
![2024 Predicted Probabilities](https://github.com/antonycj/vote-choice-anes/blob/main/images/2024_predicted_probabilities.png)

**Findings Summary:**  
- **Leadership** and **honesty** remain the strongest predictors of vote choice, but their effects are now closely intertwined with **partisan identification**.  
- Predicted probability plots show near-total alignment between partisan ID and candidate evaluation — evidence of **ideological sorting**.  
- Voters increasingly evaluate candidate character through a **partisan lens**, reinforcing polarization rather than moderating it.


## 📬 Contact
**David Jackson**  
📧 [Adavidj59@gmail.com](mailto:Adavidj59@gmail.com)
