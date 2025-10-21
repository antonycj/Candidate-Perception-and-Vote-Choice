##### ANES 2020 Data for MA Capstone #####

##### A. David Jackson #####

##### Created 3/4/2025 #####

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

setwd("C:/Users/adavi/OneDrive - University of Missouri/Desktop/Data/anes_timeseries_2020_stata_20220210") # set wd

anes_2020 <- read_dta("anes_timeseries_2020_stata_20220210.dta")
View(anes_2020)

anes_2020 <- as.data.frame(anes_2020)

########## data transformation and cleaning ##########
##### ideology variables #####

### respondent variables ###

## respondent ideology ##
# 1 = extremely liberal, 7 = extremely cons
table(anes_2020$V201200)
anes_2020$res_ideol <- replace(anes_2020$V201200, anes_2020$V201200 %in% c(-9, -8, 99), NA)
table(anes_2020$res_ideol)

## respondent pid ##
#1 = strong dem, 7 = strong rep
table(anes_2020$V201231x)
anes_2020$pid <- replace(anes_2020$V201231x, anes_2020$V201231x %in% c(-9, -8), NA)
table(anes_2020$pid)

### candidate/party variables ###
## where would r place Joe Biden on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes_2020$V201202)
anes_2020$hil_ideol_placement <- replace(anes_2020$V201202, anes_2020$V201202 %in% c(-9, -8, -4), NA)
table(anes_2020$hil_ideol_placement)

## where would r place Donald Trump on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes_2020$V201203)
anes_2020$don_ideol_placement <- replace(anes_2020$V201203, anes_2020$V201203 %in% c(-9, -8, -4), NA)
table(anes_2020$don_ideol_placement)


##### ideology spatial variables #####
# for location as compared to pres candidates 1 being extremely lib, 7 being extremely conservative
anes_2020$candideol_spatial_squared <- ((anes_2020$hil_ideol_placement - anes_2020$res_ideol)^2) - 
  ((anes_2020$don_ideol_placement - anes_2020$res_ideol)^2)
anes_2020$candideol_spatial <- sign(anes_2020$candideol_spatial_squared) * sqrt(abs(anes_2020$candideol_spatial_squared))
table(anes_2020$candideol_spatial)
hist(anes_2020$candideol_spatial)


##### valence traits of pres candidates #####
##### all of these are coded 1-5 where 1 suggests that the term describes the candidate extremely well
##### and 5 suggests that the term does not describe the candidate well at all
##### I also include a variable that includes the difference for each respondent between candidates for each issue

### politician honesty? ###
# republican honesty
anes_2020$rep_honest <- replace(anes_2020$V201215, anes_2020$V201215 %in% c(-8, -9), NA)
table(anes_2020$rep_honest)

# democratic honesty
anes_2020$dem_honest <- replace(anes_2020$V201211, anes_2020$V201211 %in% c(-8,-9), NA)
table(anes_2020$dem_honest)

# honesty difference
anes_2020$honest_diff <- anes_2020$dem_honest - anes_2020$rep_honest

### strong leadership ###
# r leadership
anes_2020$rep_leadership <- replace(anes_2020$V201212, anes_2020$V201212 %in% c(-8, -9), NA)
table(anes_2020$rep_leadership)

# d leadership
anes_2020$dem_leadership <- replace(anes_2020$V201208, anes_2020$V201208 %in% c(-8, -9), NA)
table(anes_2020$dem_leadership)

# leadership difference
anes_2020$leadership_diff <- anes_2020$dem_leadership - anes_2020$rep_leadership

### knowledgeable ###
# r knowledgeable
anes_2020$rep_knowledgeable <- replace(anes_2020$V201214, anes_2020$V201214 %in% c(-8, -9), NA)
table(anes_2020$rep_knowledgeable)

# d knowledgeable
anes_2020$dem_knowledgeable <- replace(anes_2020$V201210, anes_2020$V201210 %in% c(-8, -9), NA)
table(anes_2020$dem_knowledgeable)

# knowledgeable difference
anes_2020$knowledge_diff <- anes_2020$dem_knowledgeable - anes_2020$rep_knowledgeable

### really cares ###
# r really cares
table(anes_2020$V201213)
anes_2020$rep_cares <- replace(anes_2020$V201213, anes_2020$V201213 %in% c(-8, -9), NA)
table(anes_2020$rep_cares)
anes_2020

table(anes_2020$V201209)
anes_2020$dem_cares <- replace(anes_2020$V201209, anes_2020$V201209 %in% c(-8, -9), NA)
table(anes_2020$dem_cares)

# really cares difference
anes_2020$cares_diff <- anes_2020$dem_cares - anes_2020$rep_cares

# sum of the valence dimensions
anes_2020$valence_sum <- anes_2020$honest_diff + 
  anes_2020$leadership_diff + 
  anes_2020$knowledge_diff + 
  anes_2020$cares_diff

##### residualization of partisanship and valence issues #####
# Variables you want to residualize
vars <- c("honest_diff", "leadership_diff", "knowledge_diff", 
          "cares_diff", "valence_sum")

# Loop over each variable, regress on pid, and save residuals
for (v in vars) {
  model <- lm(as.formula(paste(v, "~ pid")), data = anes_2020, na.action = na.exclude)
  anes_2020[[paste0(v, "_resid")]] <- resid(model)
}

# Check results
head(anes_2020[, c(vars, paste0(vars, "_resid"))])


##### policy issues #####
##### all of these are coded 1-7, individual discussion of what these represent are provided for each groupin
##### these also have the self placement and then placement of both presidential candidates
### government services ###
### 1 is gov should provide many fewer services, 7 is should provide many more
# self-placement
table(anes_2020$V201246)
anes_2020$r_govspend <- replace(anes_2020$V201246, anes_2020$V201246 %in% c(-8, -9, 99), NA)
table(anes_2020$r_govspend)

# dem placement (by respondent)
table(anes_2020$V201247)
anes_2020$r_dem_govspend <- replace(anes_2020$V201247, anes_2020$V201247 %in% c(-8, -9, 99), NA)
table(anes_2020$r_dem_govspend)

# rep placement
table(anes_2020$V201248)
anes_2020$r_rep_govspend <- replace(anes_2020$V201248, anes_2020$V201248 %in% c(-8, -9, 99), NA)
table(anes_2020$r_rep_govspend)

### gov spending spatial ###
anes_2020$govspend_spatial_squared <- ((anes_2020$r_dem_govspend - anes_2020$r_govspend)^2) - 
  ((anes_2020$r_rep_govspend - anes_2020$r_govspend)^2)
anes_2020$govspend_spatial <- sign(anes_2020$govspend_spatial_squared) * sqrt(abs(anes_2020$govspend_spatial_squared))
#hist(anes_2020$govspend_spatial)

### defense spending ###
### 1 is less def spending, 7 is increase
# self-placement
table(anes_2020$V201249)
anes_2020$r_defspend <- replace(anes_2020$V201249, anes_2020$V201249 %in% c(-8, -9, 99), NA)
table(anes_2020$r_defspend)

# dem placement (by respondent)
table(anes_2020$V201250)
anes_2020$r_dem_defspend <- replace(anes_2020$V201250, anes_2020$V201250 %in% c(-8, -9, 99), NA)
table(anes_2020$r_dem_defspend)

# rep placement
table(anes_2020$V201251)
anes_2020$r_rep_defspend <- replace(anes_2020$V201251, anes_2020$V201251 %in% c(-8, -9, 99), NA)
table(anes_2020$r_rep_defspend)

# spatial variable and spatial squared variable
anes_2020$defspend_spatial_squared <- ((anes_2020$r_dem_defspend - anes_2020$r_defspend)^2) - 
  ((anes_2020$r_rep_defspend - anes_2020$r_defspend)^2)
anes_2020$defspend_spatial <- sign(anes_2020$defspend_spatial_squared) * sqrt(abs(anes_2020$defspend_spatial_squared))
#hist(anes_2020$defspend_spatial)

### priv/gov healthcare ###
### 1 is gov insurance, 7 is private
# self-placement
table(anes_2020$V201252)
anes_2020$r_healthcare <- replace(anes_2020$V201252, anes_2020$V201252 %in% c(-8, -9, 99), NA)
table(anes_2020$r_healthcare)

# dem placement (by respondent)
table(anes_2020$V201253)
anes_2020$r_dem_healthcare <- replace(anes_2020$V201253, anes_2020$V201253 %in% c(-8, -9, 99), NA)
table(anes_2020$r_dem_healthcare)

# rep placement
table(anes_2020$V201254)
anes_2020$r_rep_healthcare <- replace(anes_2020$V201254, anes_2020$V201254 %in% c(-8, -9, 99), NA)
table(anes_2020$r_rep_healthcare)

# healthcare spatial and spatial squared
anes_2020$healthcare_spatial_squared <- ((anes_2020$r_dem_healthcare - anes_2020$r_healthcare)^2) - 
  ((anes_2020$r_rep_healthcare - anes_2020$r_healthcare)^2)
anes_2020$healthcare_spatial <- sign(anes_2020$healthcare_spatial_squared) * sqrt(abs(anes_2020$healthcare_spatial_squared))
#hist(anes_2020$healthcare_spatial)

### gov assistance to blacks ###
### 1 is gov should help blacks, 7 is blacks should help themselves
# self-placement
table(anes_2020$V201258)
anes_2020$r_black_assistance <- replace(anes_2020$V201258, anes_2020$V201258 %in% c(-8, -9, 99), NA)
table(anes_2020$r_black_assistance)

# dem placement (by respondent)
table(anes_2020$V201259)
anes_2020$r_dem_aa_assistance <- replace(anes_2020$V201259, anes_2020$V201259 %in% c(-8, -9, 99), NA)
table(anes_2020$r_dem_aa_assistance)

# rep placement
table(anes_2020$V201260)
anes_2020$r_rep_aa_assistance <- replace(anes_2020$V201260, anes_2020$V201260 %in% c(-8, -9, 99), NA)
table(anes_2020$r_rep_aa_assistance)

### assistance to african americans spatial and spatial squared
anes_2020$blackassist_spatial_squared <- ((anes_2020$r_dem_aa_assistance - anes_2020$r_black_assistance)^2) - 
  ((anes_2020$r_rep_aa_assistance - anes_2020$r_black_assistance)^2)
anes_2020$blackassist_spatial <- sign(anes_2020$blackassist_spatial_squared) * sqrt(abs(anes_2020$blackassist_spatial_squared))
#hist(anes_2020$blackassist_spatial)

### environment/job tradeoff ###
### 1 is gov regulation to protect environments, 7 is not because it will cost jobs
# self-placement
table(anes_2020$V201262)
anes_2020$r_enviroment_jobs <- replace(anes_2020$V201262, anes_2020$V201262 %in% c(-8, -9, 99), NA)
table(anes_2020$r_enviroment_jobs)

# dem placement (by respondent)
table(anes_2020$V201263)
anes_2020$r_dem_enviroment_jobs <- replace(anes_2020$V201263, anes_2020$V201263 %in% c(-8, -9, 99), NA)
table(anes_2020$r_dem_enviroment_jobs)

# rep placement
table(anes_2020$V201264)
anes_2020$r_rep_enviroment_jobs <- replace(anes_2020$V201264, anes_2020$V201264 %in% c(-8, -9, 99), NA)
table(anes_2020$r_rep_enviroment_jobs)

# environment/jobs spatial 
anes_2020$env_spatial_squared <- ((anes_2020$r_dem_enviroment_jobs - anes_2020$r_enviroment_jobs)^2) - 
  ((anes_2020$r_rep_enviroment_jobs - anes_2020$r_enviroment_jobs)^2)
anes_2020$env_spatial <- sign(anes_2020$env_spatial_squared) * sqrt(abs(anes_2020$env_spatial_squared))
                                        

##### demographic and other variables #####
# respondent age 
table(anes_2020$V201507x)
anes_2020$res_age <- replace(anes_2020$V201507x, anes_2020$V201507x %in% c(-8, -9), NA)
table(anes_2020$res_age)

# respondent education
anes_2020 <- anes_2020 %>%
  mutate(
    res_educ = na_if(V201510, 90),   # replace invalids with NA
    res_educ = na_if(res_educ, 95),
    res_educ = na_if(res_educ, -9),
    res_educ = na_if(res_educ, -8),
    res_educ = case_when(
      res_educ == 1            ~ 1,  # <hsdiploma
      res_educ == 2            ~ 2,  # hsdiploma
      res_educ %in% 3:4         ~ 3,  # somecollege
      res_educ %in% 6:8         ~ 4,  # >bachelor
      TRUE ~ NA_real_
    ),
    res_educ = factor(
      res_educ,
      levels = 1:4,
      labels = c("<hsdiploma", "hsdiploma", "somecollege", ">bachelor")
    )
  )
table(anes_2020$res_educ)

# respondent race
table(anes_2020$V201549x)
# Recode invalid values as NA
anes_2020$res_race <- replace(anes_2020$V201549x, 
                              anes_2020$V201549x %in% c(-2, -8, -9), 
                              NA)
anes_2020$res_race <- ifelse(anes_2020$res_race == 3, 4,
                             ifelse(anes_2020$res_race == 4, 3, 
                                    anes_2020$res_race))
anes_2020$res_race <- as.factor(anes_2020$res_race)
table(anes_2020$res_race)
class(anes_2020$res_race)

# respondent income
table(anes_2020$V202468x)
anes_2020$V202468x
anes_2020$res_income <- replace(
  anes_2020$V202468x, 
  anes_2020$V202468x %in% c(-9, -5), 
  NA
)
anes_2020$res_income <- cut(
  anes_2020$res_income,
  breaks = c(0, 3, 7, 10, 14, 16, 19, 21, 22),  # cut points
  labels = c(">19k", "20-39K", "40-59K", "60-79K",
             "80-99k", "100-149k", "150-249k", ">250K"),
  right = TRUE,
  include.lowest = TRUE
)

table(anes_2020$res_income, useNA = "ifany")
summary(anes_2020$res_income)



# vote variable
table(anes_2020$V202073)
anes_2020$vote <- replace(anes_2020$V202073, anes_2020$V202073 %in% c(-9, -8, -7, -6, -1, 3, 4, 5, 7, 8, 9, 10, 11, 12), NA)
anes_2020$vote <- (anes_2020$vote - 1)
table(anes_2020$vote)
anes_2020$V202073
#biden is 0, trump is 1


########## regressions ##########
# simple regressions
reg1_2020 <- glm(vote ~
                   valence_sum,
                 data = anes_2020,
                 family = binomial)

summary(reg1_2020)

reg2_2020 <- glm(vote ~ 
                   honest_diff +
                   cares_diff +
                   knowledge_diff +
                   leadership_diff,
                 data = anes_2020,
                 family = binomial)

summary(reg2_2020)


# model 1
model1_2020 <- glm(vote ~ 
                honest_diff_resid +
                leadership_diff_resid +
                knowledge_diff_resid + 
                cares_diff_resid +
                pid + 
                candideol_spatial +
                govspend_spatial +
                defspend_spatial +
                blackassist_spatial +
                env_spatial + 
                healthcare_spatial +
                res_educ +
                res_age +
                as.numeric(res_income) + 
                res_race,
              data = anes_2020,
              family = binomial
)

summary(model1_2020)

# model 2
model2_2020 <- glm(vote ~
                valence_sum_resid +
                pid +
                candideol_spatial +
                govspend_spatial +
                defspend_spatial +
                blackassist_spatial +
                env_spatial + 
                healthcare_spatial +
                res_educ +
                res_age +
                as.numeric(res_income) + 
                res_race,
              data = anes_2020,
              family = binomial
)
summary(model2_2020)



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

p1 <- ggplot(anes_2020, aes(x = honest_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Honest") +
  my_theme

p2 <- ggplot(anes_2020, aes(x = leadership_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Strong Leadership") +
  my_theme

p3 <- ggplot(anes_2020, aes(x = knowledge_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Knowledgeable") +
  my_theme

p4 <- ggplot(anes_2020, aes(x = cares_diff_resid)) +
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
  body_add_par("Figure 1. Trait evaluations of candidates (ANES 2020).", style = "Image Caption")

print(doc, target = "ANES_2020_histograms.docx")

##### ideology spatial dimension #####
ideology_2020 <- ggplot(anes_2020, aes(x = candideol_spatial)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Ideology Spatial Variable") +
  my_theme

doc2 <- read_docx() %>%
  body_add_gg(value = ideology_2020, width = 6, height = 6) %>%
  body_add_par("Figure 2. Distribution of ideology spatial variable (ANES 2020).", 
               style = "Image Caption")

print(doc2, target = "ANES_2020_ideology.docx")

 


##### partisan graph #####
pidgraph <- ggplot(anes_2020, aes(x = pid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Party Identification") +
  my_theme
pidgraph

doc3 <- read_docx() %>%
  body_add_gg(value = pidgraph, width = 6, height = 6) %>%
  body_add_par("Figure 3. Distribution of party identification (ANES).", 
               style = "Image Caption")

print(doc3, target = "ANES_pid.docx")

##### predicted Values for main model #####

# Tidy up model and drop intercept + demographics
tidy_model <- tidy(model1_2020, exponentiate = TRUE, conf.int = TRUE) %>%
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
  mutate(term_label = labels[term])%>%
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
       title = "Odds Ratio (ANES 2020)") +
  theme_minimal(base_size = 14) +
  theme(
    text = element_text(family = "Times New Roman"),  # change font here
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
print(doc, target = "forest_plot.docx")

##### regression tables #####
# Map coefficients to readable names (you can extend this for intercept or demographics)
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
  `res_educ>bachelor`      = "Bachelor's or Higher Degree",
  `as.numeric(res_income)`   = "Respondent Income",
  res_age                = "Respondent Age",
  res_race2              = "Black",
  res_race3              = "Asian",
  res_race4              = "Hispanic",
  res_race5              = "Other/Multiple"
  # Add other demographics here if needed
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model1_2020,
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


# Save regression output for model1_2020
print(doc, target = "model1_2020_table.docx")

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
  res_income             = "Respondent Income",
  res_age                = "Respondent Age",
  res_race2              = "Black",
  res_race3              = "Asian",
  res_race4              = "Hispanic",
  res_race5              = "Other/Multiple"
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model2_2020,
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
print(doc, target = "model2_2020_table.docx")
