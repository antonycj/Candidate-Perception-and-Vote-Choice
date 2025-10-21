##### ANES 2016 Data for MA Capstone #####

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

setwd("C:/Users/adavi/OneDrive - University of Missouri/Desktop/Data/anes_timeseries_2016_dta") # set wd

anes <- read_dta("anes_timeseries_2016.dta")
View(anes)

anes <- as.data.frame(anes)

########## data transformation and cleaning ##########
##### ideology variables #####

### respondent variables ###

## respondent ideology ##
# 1 = extremely liberal, 7 = extremely cons
table(anes$V161126)
anes$res_ideol <- replace(anes$V161126, anes$V161126 %in% c(-9, -8, 99), NA)
table(anes$res_ideol)

## repsondent pid ##
#1 = strong dem, 7 = strong rep
table(anes$V161158x)
anes$pid <- replace(anes$V161158x, anes$V161158x %in% c(-9, -8), NA)
table(anes$pid)

### candidate/party variables ###
## where would r place Hilary clnton on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes$V161128)
anes$hil_ideol_placement <- replace(anes$V161128, anes$V161128 %in% c(-9, -8), NA)
table(anes$hil_ideol_placement)

## where would r place Donald Trump on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes$V161129)
anes$don_ideol_placement <- replace(anes$V161129, anes$V161129 %in% c(-9, -8), NA)
table(anes$don_ideol_placement)

## where would r place dem party on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes$V161130)
anes$dem_ideol_placement <- replace(anes$V161130, anes$V161130 %in% c(-9, -8), NA)
table(anes$dem_ideol_placement)

## where would r place rep party on a 7pt ideology scale ##
# 1 = extremely lib, 7 = extremely cons
table(anes$V161131)
anes$rep_ideol_placement <- replace(anes$V161131, anes$V161131 %in% c(-9, -8), NA)
table(anes$rep_ideol_placement)


##### ideology spatial variables #####
# for location as compared to parties 1 being extremely lib, 7 being extremely conservative
anes$partyideol_spatial_squared <- ((anes$dem_ideol_placement - anes$res_ideol)^2) - 
  ((anes$rep_ideol_placement - anes$res_ideol)^2)
anes$partyideol_spatial <- sign(anes$partyideol_spatial_squared) * sqrt(abs(anes$partyideol_spatial_squared))
table(anes$partyideol_spatial)

# for location as compared to pres candidates 1 being extremely lib, 7 being extremely conservative
anes$candideol_spatial_squared <- ((anes$hil_ideol_placement - anes$res_ideol)^2) - 
  ((anes$don_ideol_placement - anes$res_ideol)^2)
anes$candideol_spatial <- sign(anes$candideol_spatial_squared) * sqrt(abs(anes$candideol_spatial_squared))
table(anes$candideol_spatial)
hist(anes$candideol_spatial)




##### valence traits of pres candidates #####
##### all of these are coded 1-5 where 1 suggests that the term describes the candidate extremely well
##### and 5 suggests that the term does not describe the candidate well at all
##### I also include a variable that includes the difference for each respondent between candidates for each issue

### politician honesty? ###
# republican honesty
anes$rep_honest <- replace(anes$V161167, anes$V161167 %in% c(-8, -9), NA)
table(anes$rep_honest)

# democratic honesty
anes$dem_honest <- replace(anes$V161162, anes$V161162 %in% c(-8,-9), NA)
table(anes$dem_honest)
hist(anes$dem_honest)
hist(anes$rep_honest)

# honesty rep_honest# honesty difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much more honest
# rs view republicans
anes$honest_diff <- anes$dem_honest - anes$rep_honest
hist(anes$honest_diff)

### strong leadership ###
# r leadership
anes$rep_leadership <- replace(anes$V161164, anes$V161164 %in% c(-8, -9), NA)
table(anes$rep_leadership)

# d leadership
anes$dem_leadership <- replace(anes$V161159, anes$V161159 %in% c(-8, -9), NA)
table(anes$dem_leadership)

# leadership difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much stronger leadership
# rs view republicans
anes$leadership_diff <- anes$dem_leadership - anes$rep_leadership

### knowledgeable ###
# r knowledgeable
anes$rep_knowledgeable <- replace(anes$V161166, anes$V161166 %in% c(-8, -9), NA)
table(anes$rep_knowledgeable)

# d knowledgeable
anes$dem_knowledgeable <- replace(anes$V161161, anes$V161161 %in% c(-8, -9), NA)
table(anes$dem_knowledgeable)

# knowledgeable difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much more knowledgeable
# rs view republicans
anes$knowledge_diff <- anes$dem_knowledgeable - anes$rep_knowledgeable

### really cares ###
# r really cares
table(anes$V161165)
anes$rep_cares <- replace(anes$V161165, anes$V161165 %in% c(-8, -9), NA)
table(anes$rep_cares)

table(anes$V161160)
anes$dem_cares <- replace(anes$V161160, anes$V161160 %in% c(-8, -9), NA)
table(anes$dem_cares)

# really cares difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much more honest
# rs view republicans
anes$cares_diff <- anes$dem_cares - anes$rep_cares

### speaks mind ###
# r speaks mind
table(anes$V161168)
anes$rep_speaksmind <- replace(anes$V161168, anes$V161168 %in% c(-8, -9), NA)
table(anes$rep_speaksmind)

# d speaks mind
table(anes$V161163)
anes$dem_speaksmind <- replace(anes$V161163, anes$V161163 %in% c(-8, -9), NA)
table(anes$dem_speaksmind)

# speaks mind difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much cand speaks mind
# rs view republicans
anes$speaksmind_diff <- anes$dem_speaksmind - anes$rep_speaksmind

### even tempered ###
# rep is even tempered
table(anes$V161170)
anes$rep_temper <- replace(anes$V161170, anes$V161170 %in% c(-8, -9), NA)
table(anes$rep_cares)

# d is even tempered
table(anes$V161169)
anes$dem_temper <- replace(anes$V161169, anes$V161169 %in% c(-8, -9), NA)
table(anes$dem_temper)

# even tempered difference
# because the numbers are inverted (1 is high and 5 is low) I do dem minus rep to see how much more even tempered
# rs view republicans
anes$temper_diff <- anes$dem_temper - anes$rep_temper

# sum of the valence dimensions
anes$valence_sum <- anes$honest_diff + anes$leadership_diff +anes$knowledge_diff + anes$cares_diff 





##### policy issues #####
##### all of these are coded 1-7, individual discussion of what these represent are provided for each groupin
##### these also have the self placement and then placement of both presidential candidates

### government services ###
### 1 is gov should provide many fewwer services, 7 is should provide many more
# self-placement
table(anes$V161178)
anes$r_govspend <- replace(anes$V161178, anes$V161178 %in% c(-8, -9, 99), NA)
table(anes$r_govspend)

# dem placement (by respondent)
table(anes$V161179)
anes$r_dem_govspend <- replace(anes$V161179, anes$V161179 %in% c(-8, -9, 99), NA)
table(anes$r_dem_govspend)

# rep placment
table(anes$V161180)
anes$r__rep_govspend <- replace(anes$V161180, anes$V161180 %in% c(-8, -9, 99), NA)
table(anes$r_rep_govspend)

### gov spendig spatial ###
anes$govspend_spatial_squared <- ((anes$r_dem_govspend - anes$r_govspend)^2) - 
  ((anes$r__rep_govspend - anes$r_govspend)^2)
anes$govspend_spatial <- sign(anes$govspend_spatial_squared) * sqrt(abs(anes$govspend_spatial_squared))
#hist(anes$govspend_spatial)

### defense spending ###
### 1 is less def spending, 7 is increase
# self-placement
table(anes$V161181)
anes$r_defspend <- replace(anes$V161181, anes$V161181 %in% c(-8, -9, 99), NA)
table(anes$r_defspend)

# dem placement (by respondent)
table(anes$V161182)
anes$r_dem_defspend <- replace(anes$V161182, anes$V161182 %in% c(-8, -9, 99), NA)
table(anes$r_dem_defspend)

# rep placment
table(anes$V161183)
anes$r__rep_defspend <- replace(anes$V161183, anes$V161183 %in% c(-8, -9, 99), NA)
table(anes$r_rep_defspend)

# spatial variable and spatial squared variable
anes$defspend_spatial_squared <- ((anes$r_dem_defspend - anes$r_defspend)^2) - 
  ((anes$r__rep_defspend - anes$r_defspend)^2)
anes$defspend_spatial <- sign(anes$defspend_spatial_squared) * sqrt(abs(anes$defspend_spatial_squared))
#hist(anes$defspend_spatial)



### priv/gov healthcare ###
### 1 is gov insurance, 7 is private
# self-placement
table(anes$V161184)
anes$r_healthcare <- replace(anes$V161184, anes$V161184 %in% c(-8, -9, 99), NA)
table(anes$r_healthcare)

# dem placement (by respondent)
table(anes$V161185)
anes$r_dem_healthcare <- replace(anes$V161185, anes$V161185 %in% c(-8, -9, 99), NA)
table(anes$r_dem_healthcare)

# rep placment
table(anes$V161186)
anes$r__rep_healthcare<- replace(anes$V161186, anes$V161186 %in% c(-8, -9, 99), NA)
table(anes$r_rep_healthcare)

# healtchare spatial and spatial squared
anes$healthcare_spatial_squared <- ((anes$r_dem_healthcare - anes$r_healthcare)^2) - 
  ((anes$r__rep_healthcare - anes$r_healthcare)^2)
anes$healthcare_spatial <- sign(anes$healthcare_spatial_squared) * sqrt(abs(anes$healthcare_spatial_squared))
#hist(anes$healthcare_spatial)



### gov assistance to blacks ###
### 1 is gov should help blacks, 7 is blacks should help themselves
# self-placement
table(anes$V161198)
anes$r_black_assistance <- replace(anes$V161198, anes$V161198 %in% c(-8, -9, 99), NA)
table(anes$r_black_assistance)

# dem placement (by respondent)
table(anes$V161199)
anes$r_dem_aa_assistance <- replace(anes$V161199, anes$V161199 %in% c(-8, -9, 99), NA)
table(anes$r_dem_aa_assistance)

# rep placment
table(anes$V161200)
anes$r_rep_aa_assistance <- replace(anes$V161200, anes$V161200 %in% c(-8, -9, 99), NA)
table(anes$r_rep_aa_assistance)

### assistance to african americans spatial and spatial squared
anes$blackassist_spatial_squared <- ((anes$r_dem_aa_assistance - anes$r_black_assistance)^2) - 
  ((anes$r_rep_aa_assistance - anes$r_black_assistance)^2)
anes$blackassist_spatial <- sign(anes$blackassist_spatial_squared) * sqrt(abs(anes$blackassist_spatial_squared))
#hist(anes$blackassist_spatial)



### enviroment/job tradeoff ###
### 1 is gov regulation to protect enviroments, 7 is not because it will cost jobs
# self-placement
table(anes$V161201)
anes$r_enviroment_jobs <- replace(anes$V161201, anes$V161201 %in% c(-8, -9, 99), NA)
table(anes$r_enviroment_jobs)

# dem placement (by respondent)
table(anes$V161202)
anes$r_dem_enviroment_jobs <- replace(anes$V161202, anes$V161202 %in% c(-8, -9, 99), NA)
table(anes$r_dem_enviroment_jobs )

# rep placment
table(anes$V161203)
anes$r_rep_enviroment_jobs  <- replace(anes$V161203, anes$V161203 %in% c(-8, -9, 99), NA)
table(anes$r_rep_enviroment_jobs )

# enviroment/jobs spatial 
anes$env_spatial_squared <- ((anes$r_dem_enviroment_jobs - anes$r_enviroment_jobs)^2) - 
  ((anes$r_rep_enviroment_jobs - anes$r_enviroment_jobs)^2)
anes$env_spatial <- sign(anes$env_spatial_squared) * sqrt(abs(anes$env_spatial_squared))







##### demographic and other variables #####
# respondent age 
table(anes$V161267)
anes$res_age <- replace(anes$V161267, anes$V161267 %in% c(-8, -9), NA)
table(anes$res_age)

# respondent education
table(anes$V161270)
anes$res_educ <- replace(anes$V161270, anes$V161270 %in% c(90, 95 , -9, -8), NA)
table(anes$res_educ)
anes$res_educ

anes <- anes %>%
  mutate(
    res_educ = na_if(V161270, 90),       # replace invalids with NA
    res_educ = na_if(res_educ, 95),
    res_educ = na_if(res_educ, -9),
    res_educ = na_if(res_educ, -8),
    res_educ = case_when(
      res_educ %in% 1:8  ~ "<hsdiploma",
      res_educ == 9      ~ "hsdiploma",
      res_educ %in% 10:12 ~ "somecollege",
      res_educ %in% 13:16 ~ ">bachelor",
      TRUE ~ NA_character_
    )
  )


# respondent race
table(anes$V161310x)
anes$res_race <- replace(anes$V161310x, anes$V161310x %in% c(-2), NA)
table(anes$res_race)
anes$res_race <- as.factor(anes$res_race)
class(anes$res_race)
# here, 1 = white, 2 = black, 3 = AAPI, 4 = hispanic, 6 = other


# respondent income
table(anes$V161361x)
anes$res_income <- replace(anes$V161361x, anes$V161361x %in% c(-9, -5), NA)

# Collapse categories
anes$res_income <- cut(
  anes$res_income,
  breaks = c(0, 6, 12, 16, 20, 22, 25, 27, 28),  # define the category cut points
  labels = c(">19k", "20-39K", "40-59K", "60-79K", "80-99k", "100-149k", "150-249k",
             ">250K"),
  right = TRUE,
  include.lowest = TRUE
)
table(anes$res_income, useNA = "ifany")
summary(anes$res_income)


# vote variable
table(anes$V162034a)
anes$vote <- replace(anes$V162034a, anes$V162034a %in% c(-9, -8, -7, -6, -1, 3, 4, 5, 7, 9), NA)
anes$vote <- (anes$vote - 1)
table(anes$vote)

#0 is hilary, 1 is donald



##### residualization of partisanship and valence issues #####
# Variables you want to residualize
vars <- c("honest_diff", "leadership_diff", "knowledge_diff", 
          "cares_diff", "valence_sum" )

# Loop over each variable, regress on pid, and save residuals
for (v in vars) {
  model <- lm(as.formula(paste(v, "~ pid")), data = anes, na.action = na.exclude)
  anes[[paste0(v, "_resid")]] <- resid(model)
}

# Check results
head(anes[, c(vars, paste0(vars, "_resid"))])



########## Regressions ##########
# Simple regressions with vote as the DV
simple_reg1 <- glm((vote) ~ 
                      honest_diff_resid + 
                      leadership_diff_resid +
                      knowledge_diff_resid + 
                      cares_diff_resid,
                    data = anes, 
                    family = binomial)
summary(simple_reg1)

simple_reg2 <- glm((vote) ~
                      valence_sum_resid,
                    data = anes,
                    family = binomial)
summary(simple_reg2)

# more complicated models
model1 <- glm(vote ~ 
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
              data = anes,
              family = binomial
            )
summary(model1)

model2 <- glm(vote ~
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
              data = anes,
              family = binomial
)
summary(model2)



########## visualizations ##########
##### histograms for valence #####
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

p1 <- ggplot(anes, aes(x = honest_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Honest") +
  my_theme


p2 <- ggplot(anes, aes(x = leadership_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Strong Leadership") +
  my_theme

p3 <- ggplot(anes, aes(x = knowledge_diff_resid)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Knowledgeable") +
  my_theme
p3

p4 <- ggplot(anes, aes(x = cares_diff_resid)) +
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
    "Negative values indicates that respondents think the Democratic candidate better display the valence trait displayed,
     while positive indicate they think the Republican candidate better displays the trait.",
    gp = gpar(fontfamily = "Times New Roman", fontsize = 12)
  )
)

# Combine ggplots with patchwork
grid_plot <- (p1 | p2) / (p3 | p4)

# Create Word doc and insert figure + caption
doc <- read_docx() %>%
  body_add_gg(value = grid_plot, width = 6, height = 6) %>%
  body_add_par("Figure 1. Trait evaluations of candidates (ANES 2020).", style = "Image Caption")

print(doc, target = "ANES_histograms.docx")


##### ideology spatial dimension #####
ideology_2016 <- ggplot(anes, aes(x = candideol_spatial)) +
  geom_histogram(binwidth = 1, fill = "steelblue", color = "black") +
  labs(title = "Ideology Spatial Variable") +
  my_theme

doc2 <- read_docx() %>%
  body_add_gg(value = ideology_2016, width = 6, height = 6) %>%
  body_add_par("Figure 2. Distribution of ideology spatial variable (ANES 2016).", 
               style = "Image Caption")

print(doc2, target = "ANES_ideology.docx")



##### partisan graph #####
pidgraph <- ggplot(anes, aes(x = pid)) +
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
tidy_model <- tidy(model1, exponentiate = TRUE, conf.int = TRUE) %>%
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
  healthcare_spatial    = "Healthcare Policy"
)

# Apply custom labels
tidy_model <- tidy_model %>%
  mutate(term_label = labels[term]) %>%
  filter(!is.na(term_label)) %>%
  mutate(term_label = factor(term_label, levels = rev(labels)))

# Plot with improvements
# Plot with improvements and Times New Roman font
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
       title = "Odds Ratio (ANES 2016)") +
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
  `res_educ>bachelor`    = "Bachelor's or Higher Degree",
  `as.numeric(res_income)` = "Respondent Income",
  res_age                = "Respondent Age",
  res_race2              = "Black",
  res_race3              = "Asian",
  res_race4              = "Hispanic",
  res_race5              = "Other/Multiple"
  # Add other demographics here if needed
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model1,
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

# Save
print(doc, target = "model1_2016_table.docx")

coef_labels2 <- c(
  `(Intercept)`          = "Intercept",
  valence_sum_resid       = "Sum of Valence Dimensions",
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
  `as.numeric(res_income)` = "Respondent Income",
  res_age                = "Respondent Age",
  res_race2              = "Black",
  res_race3              = "Asian",
  res_race4              = "Hispanic",
  res_race5              = "Other/Multiple"
  # Add other demographics here if needed
)

# Create flextable using modelsummary
reg_table_full <- modelsummary(model2,
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
print(doc, target = "model2_2016_table.docx")

