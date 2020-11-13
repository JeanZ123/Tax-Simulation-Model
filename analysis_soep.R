library(ineq)
library(haven)
library(dplyr)

# Load datasets

hbrutto <-
  read_sav("C:/Users/.../Datasets/SOEP/pequiv.sav")

wealth <-
  read_sav("C:/Users/.../Datasets/SOEP/pwealth_weight.sav")

# Weight cases by sampling weight

hbrutto <- hbrutto * hbrutto$w11102

# Calculate inequality measures for income

gini_pretax <- Gini(hbrutto$i11101, corr = FALSE, na.rm = TRUE)
gini_posttax <- Gini(hbrutto$i11102, corr = FALSE, na.rm = TRUE)

for (i in hbrutto) {
    hbrutto$adults <- hbrutto$d11106 - (1 + hbrutto$d11107)
    hbrutto$equiv <- hbrutto$i11101 / (1.0 + hbrutto$adults * 0.5 + hbrutto$d11107 * 0.3)
    trunc(hbrutto$equiv)
}

gini_pretax <- Gini(hbrutto$equiv, corr = FALSE, na.rm = TRUE)

# Calculate inequality measures for wealth

# Weight cases by sampling weight

est_sim <- est_sim * est_sim$biphrf

gini <- Gini(wealth$w0111a, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111b, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111c, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111d, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111e, corr = FALSE, na.rm = TRUE)
gini <- gini/5
