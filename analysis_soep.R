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

# Calculate inequality measures for gross household income distribution

gini_pretax <- Gini(hbrutto$i11101, corr = FALSE, na.rm = TRUE)
gini_posttax <- Gini(hbrutto$i11102, corr = FALSE, na.rm = TRUE)

# Calculate inequality measures for gross household equivalised income

for (i in hbrutto) {
    hbrutto$adults <- hbrutto$d11106 - (1 + hbrutto$d11107)
    hbrutto$equiv <- hbrutto$i11101 / (1.0 + hbrutto$adults * 0.5 + hbrutto$d11107 * 0.3)
    trunc(hbrutto$equiv)
}

gini_pretax <- Gini(hbrutto$equiv, corr = FALSE, na.rm = TRUE)

# Calculate inequality measures for household wealth distribution

# Weight cases by sampling weight

est_sim <- est_sim * est_sim$biphrf

# Impute amount of individual household wealth (using variables 'w0111a', 'w0111b', 'w0111c', 'w0111d', 'w0111e' as prescribed in the SOEP documentation)

gini <- Gini(wealth$w0111a, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111b, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111c, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111d, corr = FALSE, na.rm = TRUE)
gini <- gini + Gini(wealth$w0111e, corr = FALSE, na.rm = TRUE)
gini <- gini/5
