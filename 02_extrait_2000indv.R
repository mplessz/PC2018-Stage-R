# Generation d'un extrait de 2000 cas ----


library(tidyverse)
library(haven)

## version avec labels

data <- readRDS("data/PC18_avec_labels.RDS")

set.seed(123)

sample_n(data, size = 2000, replace = T)

saveRDS("data/PC18_extrait_avec_labels.RDS")

## version sans labels

sas <- read_sas("data/pc18_quetelet_octobre2021.sas7bdat") 

set.seed(123)

sample_n(sas, size = 2000, replace = T)

write_csv(sas,"data/pc18_extrait.csv" )

