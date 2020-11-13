library(ineq)
library(haven)
library(dplyr)

# Load dataset

est_sim <-
  read.csv2(
    "C:/Users/Marius/Desktop/Statistics/Projects/SPSS/Mikrosimulation_ESt/Gesamttabelle/est_sim_flat_tax.csv",
    header = TRUE
  )
names(est_sim)[1] <- "SamplingWeight"
View(est_sim)

# Select non-negative values

est_sim <- filter(est_sim, sde_neu > 0)

# Weigh cases by sampling weight

est_sim <- est_sim * est_sim$SamplingWeight

# Calculate secondary income variable

est_sim$income <- est_sim$sde_neu - est_sim$st20_s

# Calculate inequality measures

gini <- Gini(est_sim$income, corr = FALSE, na.rm = TRUE)
# Lc(est_sim$income, plot = TRUE)
atkinson <- Atkinson(est_sim$income, parameter = NULL, na.rm = TRUE)
theil <- Theil(est_sim$income, parameter = 0, na.rm = TRUE)