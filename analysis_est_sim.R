library(ineq)
library(haven)
library(dplyr)

# Load dataset

est_sim <-
  read.csv2(
    ""...".csv"
  )

names(est_sim)[1] <- "SamplingWeight"
est_sim <- round(est_sim)
View(est_sim)
 
# Weight cases by sampling weight

est_sim <- est_sim * est_sim$SamplingWeight

# Select non-negative values

est_sim <- filter(est_sim, zve_neu >= 0)

# Calculate secondary income variable

est_sim$income <- est_sim$zve_neu - est_sim$st20_s

# Calculate 90/10 ratio

quantile(est_sim$income, probs = c(0.1, 0.9), na.rm = TRUE)
p1 <- filter(est_sim, income <= 3687)
p10 <- filter(est_sim, income >= 137376)
ratio <- sum(p10$income) / sum(p1$income)

# Calculate inequality measures

gini <- Gini(est_sim$income, corr = FALSE, na.rm = TRUE)
Lc(est_sim$income, plot = TRUE)
atkinson <- Atkinson(est_sim$income, parameter = NULL, na.rm = TRUE)
theil <- Theil(est_sim$income, parameter = 0, na.rm = TRUE)
gei <- calcGEI(est_sim$income, est_sim$SamplingWeight, alpha=1) #alpha = 1 (Theil-Index)

# Calculate progressivity measures

gini_pretax <- Gini(est_sim$sde_neu, corr = FALSE, na.rm = TRUE)
gini_tax <- Gini(est_sim$st20_s, corr = FALSE, na.rm = TRUE)
kakwani <- gini_tax - gini_pretax
suits <- gini_pretax / gini_tax

# Calculate redistribution measures

gini_income <- Gini(est_sim$income, corr = FALSE, na.rm = TRUE)
reynolds_smolensky <- gini_pretax - gini_income
# reynolds_smolensky <- progressivity(est_sim$sde_neu, est_sim$st20_s, c("Reynolds-Smolensky"))
musgrave_thin <- (1 - gini_income) / (1 - gini_pretax)
