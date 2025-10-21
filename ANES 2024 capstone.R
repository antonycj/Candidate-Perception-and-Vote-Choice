##### ANES 2024 Data for MA Capstone #####

##### A. David Jackson #####

##### Created 9/2/2025 #####

######################################################################
######################################################################


library(officer)
library(flextable)
library(extrafont)
library(wnominate)
library(ggplot2)
library(patchwork)
library(tidyr)
library(dplyr)
library(car)
library(broom)
library(haven)
library(modelsummary)
library(gridExtra)
library(grid)
library(patchwork)
library(officer)

setwd("C:/Users/adavi/OneDrive - University of Missouri/Desktop/Data/anes_timeseries_2024_stata_20250808") # set wd

anes_2024 <- read_dta("anes_timeseries_2024_stata_20250808.dta")
View(anes_2024)

anes_2024 <- as.data.frame(anes_2024)

########## cleaning ##########
##### ideology variables #####
# self placement 1 = lib 7 = con
table(anes_2024$V241177)
anes_2024$res_ideol <- replace(anes_2024$V241177, anes_2024$V241177 %in% c(-9, -4, 99), NA)
table(anes_2024$res_ideol)

# dem can place
table(anes_2024$V241179)
anes_2024$dem_cand_ideol <- replace(anes_2024$V241179, anes_2024$V241179 %in% c(-9, -8, -4, 99), NA)
table(anes_2024$dem_cand_ideol)

# rep can place 
table(anes_2024$V241180)
anes_2024$rep_cand_ideol <- replace(anes_2024$V241180, anes_2024$V241180 %in% c(-9, -8, -4, 99), NA)
table(anes_2024$rep_cand_ideol)


##### Ideology squared #####
anes_2024$candideol_spatial_squared <- ((anes_2024$dem_cand_ideol - anes_2024$res_ideol)^2) - 
  ((anes_2024$rep_cand_ideol - anes_2024$res_ideol)^2)
anes_2024$candideol_spatial <- sign(anes_2024$candideol_spatial_squared) * sqrt(abs(anes_2024$candideol_spatial_squared))
table(anes_2024$candideol_spatial)
hist(anes_2024$candideol_spatial)

##### party ID #####
# 1 = strong dem 7 = strong rep
table(anes_2024$ V241227x)
anes_2024$pid <- replace(anes_2024$V241227x, anes_2024$V241227x %in% c(-9, -8, -4, 99), NA)
table(anes_2024$pid)

##### valence #####
### honesty 1 = very honest 7 = not
# dem 
table(anes_2024$V241203)
anes_2024$dem_honest <- replace(anes_2024$V241203, anes_2024$V241203 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$dem_honest)

# rep
table(anes_2024$V241208)
anes_2024$rep_honest <- replace(anes_2024$V241208, anes_2024$V241208 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$rep_honest)

anes_2024$honest_diff <- anes_2024$dem_honest - anes_2024$rep_honest
table(anes_2024$honest_diff)
hist(anes_2024$honest_diff)

###  knowledge 
# dem
table(anes_2024$V241202)
anes_2024$dem_knowledge <- replace(anes_2024$V241202, anes_2024$V241202 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$dem_knowledge)

# rep
table(anes_2024$V241207)
anes_2024$rep_knowledge <- replace(anes_2024$V241207, anes_2024$V241207 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$rep_knowledge)

anes_2024$knowledge_diff <- anes_2024$dem_knowledge - anes_2024$rep_knowledge
table(anes_2024$knowledge_diff)
hist(anes_2024$knowledge_diff)


### leadership
# dem 
table(anes_2024$V241200)
anes_2024$dem_leader <- replace(anes_2024$V241200, anes_2024$V241200 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$dem_leader)

#rep 
table(anes_2024$V241205)
anes_2024$rep_leader <- replace(anes_2024$V241205, anes_2024$V241205 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$rep_leader)

# spatial variable
anes_2024$leadership_diff <- anes_2024$dem_leader - anes_2024$rep_leader
table(anes_2024$leadership_diff)
hist(anes_2024$leadership_diff)

### really cares
# dem 
table(anes_2024$V241201)
anes_2024$dem_cares <- replace(anes_2024$V241201, anes_2024$V241201 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$dem_cares)

#rep
table(anes_2024$V241206)
anes_2024$rep_cares <- replace(anes_2024$V241206, anes_2024$V241206 %in% c(-9, -8, -4, -1, 99), NA)
table(anes_2024$rep_cares)

# spatial variable
anes_2024$cares_diff <- anes_2024$dem_cares - anes_2024$rep_cares
hist(anes_2024$cares_diff)

### sum of valence dimensions
anes_2024$valence_sum <- anes_2024$honest_diff + 
  anes_2024$knowledge_diff + 
  anes_2024$leadership_diff + 
  anes_2024$cares_diff

hist(anes_2024$valence_sum)

##### residuals of valence dimensions #####
vars <- c("honest_diff", "leadership_diff", "knowledge_diff", 
          "cares_diff", "valence_sum")

# Loop over each variable, regress on pid, and save residuals
for (v in vars) {
  model <- lm(as.formula(paste(v, "~ pid")), data = anes_2024, na.action = na.exclude)
  anes_2024[[paste0(v, "_resid")]] <- resid(model)
}

# Check results
head(anes_2024[, c(vars, paste0(vars, "_resid"))])

##### policy #####
### government services ###
### 1 is gov should provide many fewer services, 7 is should provide many more
# self-placement
table(anes_2024$V241239)
anes_2024$r_govspend <- replace(anes_2024$V241239, anes_2024$V241239 %in% c(-8,-4, -9, 99), NA)
table(anes_2024$r_govspend)

# dem placement (by respondent)
table(anes_2024$V241240)
anes_2024$r_dem_govspend <- replace(anes_2024$V241240, anes_2024$V241240 %in% c(-8, -4, -9, 99), NA)
table(anes_2024$r_dem_govspend)

# rep placement
table(anes_2024$V241241)
anes_2024$r_rep_govspend <- replace(anes_2024$V241241, anes_2024$V241241 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_rep_govspend)

### gov spending spatial ###
anes_2024$govspend_spatial_squared <- ((anes_2024$r_dem_govspend - anes_2024$r_govspend)^2) - 
  ((anes_2024$r_rep_govspend - anes_2024$r_govspend)^2)
anes_2024$govspend_spatial <- sign(anes_2024$govspend_spatial_squared) * sqrt(abs(anes_2024$govspend_spatial_squared))
hist(anes_2024$govspend_spatial)

### defense spending ###
### 1 is less def spending, 7 is increase
# self-placement
table(anes_2024$V241242)
anes_2024$r_defspend <- replace(anes_2024$V241242, anes_2024$V241242 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_defspend)

# dem placement (by respondent)
table(anes_2024$V241243)
anes_2024$r_dem_defspend <- replace(anes_2024$V241243, anes_2024$V241243 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_dem_defspend)

# rep placement
table(anes_2024$V241244)
anes_2024$r_rep_defspend <- replace(anes_2024$V241244, anes_2024$V241244 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_rep_defspend)

# spatial variable and spatial squared variable
anes_2024$defspend_spatial_squared <- ((anes_2024$r_dem_defspend - anes_2024$r_defspend)^2) - 
  ((anes_2024$r_rep_defspend - anes_2024$r_defspend)^2)
anes_2024$defspend_spatial <- sign(anes_2024$defspend_spatial_squared) * sqrt(abs(anes_2024$defspend_spatial_squared))
hist(anes_2024$defspend_spatial)

### priv/gov healthcare ###
### 1 is gov insurance, 7 is private
# self-placement
table(anes_2024$V241245)
anes_2024$r_healthcare <- replace(anes_2024$V241245, anes_2024$V241245 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_healthcare)

# dem placement (by respondent)
table(anes_2024$V241246)
anes_2024$r_dem_healthcare <- replace(anes_2024$V241246, anes_2024$V241246 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_dem_healthcare)

# rep placement
table(anes_2024$V241247)
anes_2024$r_rep_healthcare <- replace(anes_2024$V241247, anes_2024$V241247 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_rep_healthcare)

# healthcare spatial and spatial squared
anes_2024$healthcare_spatial_squared <- ((anes_2024$r_dem_healthcare - anes_2024$r_healthcare)^2) - 
  ((anes_2024$r_rep_healthcare - anes_2024$r_healthcare)^2)
anes_2024$healthcare_spatial <- sign(anes_2024$healthcare_spatial_squared) * sqrt(abs(anes_2024$healthcare_spatial_squared))
hist(anes_2024$healthcare_spatial)

### gov assistance to blacks ###
### 1 is gov should help blacks, 7 is blacks should help themselves
# self-placement
table(anes_2024$V241255)
anes_2024$r_black_assistance <- replace(anes_2024$V241255, anes_2024$V241255 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_black_assistance)

# dem placement (by respondent)
table(anes_2024$V241256)
anes_2024$r_dem_aa_assistance <- replace(anes_2024$V241256, anes_2024$V241256 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_dem_aa_assistance)

# rep placement
table(anes_2024$V241257)
anes_2024$r_rep_aa_assistance <- replace(anes_2024$V241257, anes_2024$V241257 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_rep_aa_assistance)

### assistance to african americans spatial and spatial squared
anes_2024$blackassist_spatial_squared <- ((anes_2024$r_dem_aa_assistance - anes_2024$r_black_assistance)^2) - 
  ((anes_2024$r_rep_aa_assistance - anes_2024$r_black_assistance)^2)
anes_2024$blackassist_spatial <- sign(anes_2024$blackassist_spatial_squared) * sqrt(abs(anes_2024$blackassist_spatial_squared))
hist(anes_2024$blackassist_spatial)

### environment/job tradeoff ###
### 1 is gov regulation to protect environments, 7 is not because it will cost jobs
# self-placement
table(anes_2024$V241258)
anes_2024$r_enviroment_jobs <- replace(anes_2024$V241258, anes_2024$V241258 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_enviroment_jobs)

# dem placement (by respondent)
table(anes_2024$V241259)
anes_2024$r_dem_enviroment_jobs <- replace(anes_2024$V241259, anes_2024$V241259 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_dem_enviroment_jobs)

# rep placement
table(anes_2024$V241260)
anes_2024$r_rep_enviroment_jobs <- replace(anes_2024$V241260, anes_2024$V241260 %in% c(-8,-4, -1, -9, 99), NA)
table(anes_2024$r_rep_enviroment_jobs)

# environment/jobs spatial 
anes_2024$env_spatial_squared <- ((anes_2024$r_dem_enviroment_jobs - anes_2024$r_enviroment_jobs)^2) - 
  ((anes_2024$r_rep_enviroment_jobs - anes_2024$r_enviroment_jobs)^2)
anes_2024$env_spatial <- sign(anes_2024$env_spatial_squared) * sqrt(abs(anes_2024$env_spatial_squared))
hist(anes_2024$env_spatial)

##### demographic #####
# respondent age 
table(anes_2024$V241458x)
anes_2024$res_age <- replace(anes_2024$V241458x, anes_2024$V241458x %in% c(-8, -9, -2), NA)
table(anes_2024$res_age)

# respondent education
anes_2024$V241463
anes_2024 <- anes_2024 %>%
  mutate(
    res_educ = na_if(V241463, 90),   # replace invalids with NA (if applicable)
    res_educ = na_if(res_educ, 95),
    res_educ = na_if(res_educ, -9),
    res_educ = na_if(res_educ, -8),
    res_educ = na_if(res_educ, -1),
    res_educ = case_when(
      res_educ %in% 1:8      ~ 1,  # <hsdiploma
      res_educ == 9          ~ 2,  # hsdiploma
      res_educ %in% 10:12    ~ 3,  # somecollege
      res_educ %in% 13:16    ~ 4,  # >bachelor
      TRUE ~ NA_real_
    ),
    res_educ = factor(
      res_educ,
      levels = 1:4,
      labels = c("<hsdiploma", "hsdiploma", "somecollege", ">bachelor")
    )
  )

table(anes_2024$res_educ)

# respondent race
anes_2024$V241501x
anes_2024 <- anes_2024 %>%
  mutate(
    res_race = case_when(
      V241501x == 1 ~ 1,                     # White
      V241501x == 2 ~ 2,                     # Black
      V241501x == 4 ~ 3,                     # Asian (old 4 becomes 3)
      V241501x == 3 ~ 4,                     # Hispanic (old 3 becomes 4)
      V241501x %in% c(5, 6) ~ 5,             # Multiple/Other
      TRUE ~ NA_real_
    ),
    res_race = factor(
      res_race,
      levels = 1:5,
      labels = c("White", "Black", "Asian", "Hispanic", "Multiple/Other")
    )
  )

table(anes_2024$res_race, useNA = "ifany")

# res income
anes_2024$V241566x

anes_2024$res_income <- replace(
  anes_2024$V241566x,
  anes_2024$V241566x %in% c(-9, -5, -4, -1),  # drop missing codes
  NA
)

# Collapse into new categories
anes_2024$res_income <- cut(
  anes_2024$res_income,
  breaks = c(0, 6, 12, 16, 20, 22, 25, 27, 28),  # cut points
  labels = c(">19k", "20-39K", "40-59K", "60-79K",
             "80-99k", "100-149k", "150-249k", ">250K"),
  right = TRUE,
  include.lowest = TRUE
)
table(anes_2024$res_income, useNA = "ifany")
summary(anes_2024$res_income)

#vote variable
table(anes_2024$V242067)

anes_2024$vote <- replace(
  anes_2024$V242067,
  anes_2024$V242067 %in% c(-9, -8, -7, -6, -1, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12), 
  NA
)

# Shift so that 1 -> 0 (Biden/Democrat), 2 -> 1 (Trump/Republican)
anes_2024$vote <- (anes_2024$vote - 1)

# Check result
table(anes_2024$vote)
anes_2024$V241039


########## regressions ##########
model1_2024 <- glm(vote ~
                     honest_diff_resid +
                     leadership_diff_resid +
                     knowledge_diff_resid +
                     cares_diff_resid +
                     pid +
                     candideol_spatial +
                     govspend_spatial +
                     defspend_spatial +
                     healthcare_spatial +
                     blackassist_spatial +
                     env_spatial +
                     res_educ +
                     as.numeric(res_income) +
                     res_age +
                     res_race,
                   data = anes_2024,
                   family = binomial)
summary(model1_2024)

model2_2024 <- glm(vote ~
                     valence_sum_resid +
                     pid +
                     candideol_spatial +
                     govspend_spatial +
                     defspend_spatial +
                     healthcare_spatial +
                     blackassist_spatial +
                     env_spatial +
                     res_educ +
                     as.numeric(res_income) +
                     res_age +
                     res_race,
                   data = anes_2024,
                   family = binomial)
summary(model2_2024)

########## visualizations ##########
##### histograms for valence #####
# Common theme settings
my_theme <- theme_minimal(base_family = "Times New Roman") +
  theme(
    axis.title.x = element_blank(),       # remove x axis label
    axis.title.y = element_blank(),       # remove y axis label
    plot.title = element_text(
      size = 14,
      face = "bold",
      hjust = 0.5                        # center titles
    )
  )

p1 <- ggplot(anes_2024, aes(x = honest_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Honest") +
  my_theme

p2 <- ggplot(anes_2024, aes(x = leadership_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Strong Leadership") +
  my_theme

p3 <- ggplot(anes_2024, aes(x = knowledge_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Knowledgeable") +
  my_theme

p4 <- ggplot(anes_2024, aes(x = cares_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Really Cares") +
  my_theme

# Arrange plots in a grid with title and description
grid_plot <- grid.arrange(
  p1, p2, p3, p4,
  ncol = 2,
  top = textGrob(
    "Distributions of Character Valence Issue Spatial Variables",
    gp = gpar(fontfamily = "Times New Roman", fontsize = 16, fontface = "bold")
  ),
  bottom = textGrob(
    "Negative values indicate that respondents think the Democratic candidate better displays the valence trait,
     while positive values indicate they think the Republican candidate better displays the trait.",
    gp = gpar(fontfamily = "Times New Roman", fontsize = 12)
  )
)

# Combine ggplots with patchwork
grid_plot <- (p1 | p2) / (p3 | p4)

# Create Word doc and insert figure + caption
doc <- read_docx() %>%
  body_add_gg(value = grid_plot, width = 6, height = 6) %>%
  body_add_par("Figure 1. Trait evaluations of candidates (ANES 2024).", style = "Image Caption")

print(doc, target = "ANES_2024_histograms.docx")

##### ideology spatial dimension #####
ideology_2024 <- ggplot(anes_2024, aes(x = candideol_spatial)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Ideology Spatial Variable") +
  my_theme

doc2 <- read_docx() %>%
  body_add_gg(value = ideology_2024, width = 6, height = 6) %>%
  body_add_par("Figure 2. Distribution of ideology spatial variable (ANES 2024).", 
               style = "Image Caption")

print(doc2, target = "ANES_2024_ideology.docx")

##### partisan graph #####
pidgraph <- ggplot(anes_2024, aes(x = pid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Party Identification") +
  my_theme
pidgraph

doc3 <- read_docx() %>%
  body_add_gg(value = pidgraph, width = 6, height = 6) %>%
  body_add_par("Figure 3. Distribution of party identification (ANES 2024).", 
               style = "Image Caption")

print(doc3, target = "ANES_2024_pid.docx")

##### predicted Values for main model #####

# Tidy up model and drop intercept + demographics
tidy_model <- tidy(model1_2024, exponentiate = TRUE, conf.int = TRUE) %>%
  filter(term != "(Intercept)") %>%
  filter(!grepl("^res_", term)) 

# Custom labels for predictors (you can edit as you like)
labels <- c(
  honest_diff_resid     = "Honesty",
  knowledge_diff_resid  = "Knowledge",
  leadership_diff_resid = "Leadership",
  cares_diff_resid      = "Cares about people",
  pid                   = "Partisanship",
  candideol_spatial     = "Ideology",
  govspend_spatial      = "Government Spending",
  defspend_spatial      = "Defense Spending",
  blackassist_spatial   = "Black Assistance",
  env_spatial           = "Environmental Policy",
  healthcare_spatial    = "Healthcare Policy",
  res_age               = "Respondent Age"
)

# Apply custom labels
tidy_model <- tidy_model %>%
  mutate(term_label = labels[term]) %>%
  filter(!is.na(term_label)) %>%
  mutate(term_label = factor(term_label, levels = rev(labels)))

plot_forest <-
  ggplot(tidy_model, aes(x = term_label,
                         y = estimate,
                         ymin = conf.low,
                         ymax = conf.high)) +
  geom_pointrange(size = 1.2, fatten = 3, color = "black") +  # thicker whiskers + bigger dots
  geom_hline(yintercept = 1, linetype = "dashed", color = "red", linewidth = 1) +
  coord_flip() +
  scale_y_log10() +  # keeps ORs readable
  labs(y = "Odds Ratio (95% CI, log scale)", x = "Predictors",
       title = "Odds Ratio (ANES 2024)") +
  theme_minimal(base_size = 14) +
  theme(
    text = element_text(family = "Times New Roman"),
    panel.border = element_rect(colour = "black", fill = NA, linewidth = 1),
    panel.grid.minor = element_blank()
  )
plot_forest

# Create a new Word document
doc <- read_docx()

# Add the plot as a vector graphic (scales well)
doc <- doc %>% 
  body_add_gg(value = plot_forest, width = 6, height = 5)

# Save the Word file
print(doc, target = "forest_plot_2024.docx")

##### regression tables #####
coef_labels <- c(
  `(Intercept)`          = "Intercept",
  honest_diff_resid      = "Honesty",
  knowledge_diff_resid   = "Knowledge",
  leadership_diff_resid  = "Leadership",
  cares_diff_resid       = "Cares about people",
  pid                    = "Partisanship",
  candideol_spatial      = "Ideology",
  govspend_spatial       = "Government Spending",
  defspend_spatial       = "Defense Spending",
  blackassist_spatial    = "Black Assistance",
  env_spatial            = "Environmental Policy",
  healthcare_spatial     = "Healthcare Policy",
  res_educhsdiploma      = "HS Diploma",
  res_educsomecollege    = "Some College/Associate's Degree",
  `res_educ>bachelor`    = "Bachelor's or Higher Degree",
  `as.numeric(res_income)` = "Respondent Income",
  res_age                = "Respondent Age",
  res_raceBlack             = "Black",
  res_raceAsian             = "AAPI",
  res_raceHispanic          = "Hispanic",
  `res_raceMultiple/Other`  = "Other/Multiple"
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model1_2024,
                               output = "flextable",
                               coef_map = coef_labels,
                               stars = TRUE,
                               estimate_format = "%.3f",
                               conf_level = 0.95)
reg_table_full

# Create Word document
doc <- read_docx() %>%
  body_add_par("Full Regression Table", style = "heading 1") %>%
  body_add_flextable(reg_table_full) %>%
  body_add_par("Table includes all predictors, demographics, and the intercept.", style = "Normal")

# Save regression output for model1_2024
print(doc, target = "model1_2024_table.docx")

coef_labels2 <- c(
  `(Intercept)`          = "Intercept",
  valence_sum_resid      = "Sum of Valence Dimensions",
  pid                    = "Partisanship",
  candideol_spatial      = "Ideology",
  govspend_spatial       = "Government Spending",
  defspend_spatial       = "Defense Spending",
  blackassist_spatial    = "Black Assistance",
  env_spatial            = "Environmental Policy",
  healthcare_spatial     = "Healthcare Policy",
  res_educhsdiploma      = "HS Diploma",
  res_educsomecollege    = "Some College/Associate's Degree",
  `res_educ>bachelor`    = "Bachelor's or Higher Degree",
  `as.numeric(res_income)`   = "Respondent Income",
  res_age                = "Respondent Age",
  res_raceBlack             = "Black",
  res_raceAsian             = "AAPI",
  res_raceHispanic          = "Hispanic",
  `res_raceMultiple/Other`  = "Other/Multiple"
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model2_2024,
                               output = "flextable",
                               coef_map = coef_labels2,
                               stars = TRUE,
                               estimate_format = "%.3f",
                               conf_level = 0.95)
reg_table_full

# Create Word document
doc <- read_docx() %>%
  body_add_par("Full Regression Table", style = "heading 1") %>%
  body_add_flextable(reg_table_full) %>%
  body_add_par("Table includes all predictors, demographics, and the intercept.", style = "Normal")

# Save
print(doc, target = "model2_2024_table.docx")

