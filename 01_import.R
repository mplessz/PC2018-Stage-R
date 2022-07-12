# IMPORT

library(tidyverse)

# library(foreign) => foreign importe en s'appuyant sur la version de sas installée sur l'ordinateur.


csv <- read.csv2("data/pc18_quetelet_octobre2021.csv")
  # aucun label

sas <- haven::read_sas("data/pc18_quetelet_octobre2021.sas7bdat")
  # labels des variables
  # pas labels des modalités
  # variables catégorielles considérées comme numériques