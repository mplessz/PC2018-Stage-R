# IMPORTER les données de l'enquête Pratiques culturelle 2018 avec les étiquettes.

# objectif ----
# 
# Importer les données avec les étiquettes (labels) de variables et de modalités.
# 
# La difficulté est double : 
#   - les packages d'import des données ne gèrent pas encore les étiquettes de valeur (voir packages rio et haven)
#   - les formats SAS fournis doivent être adaptés pour être appliqués
#   - en plus dans ces données SAS certaines colonnes étiquetées sont "character", d'autres sont "numeric".
#
# réf : https://stackoverflow.com/questions/61153101/how-do-i-add-sas-spss-format-labels-stored-as-a-txt-file-to-r 

# avant de commancer, placer les données et le fichier Format_sqldfjkmqklj.txt dans un dossier data, dans le répertoire de travail (par ex dans un projet Rstudio)

# à la fin on peut choisir de convertir toutes les variables qui ont une étiquette en facteurs. ce n'est pas obligatoire.

# charger les packages utiles ----

library(tidyverse)
library(labelled)
library(haven)

## importer les données sas ----

# ==> modifier le chemin ou le nom du fichier si besoin

PC18 <- read_sas("data/pc18_quetelet_novembre2022.sas7bdat") %>%  as_tibble

  # liste des variables numériques et charactère dans le fichier, pcq ça pose pb après.
list_char <- PC18 %>% select(where(is.character)) %>%  names

list_num <- PC18 %>% select(where(is.numeric)) %>%  names
  
  # on vérifie qu'on a bien toutes les variables
length(list_char) + length(list_num) == length(names(PC18))

## importer les formats SAS ----

formats <- read_delim("data/Format_lil-1511_SAS.txt", 
                delim = ";", escape_double = FALSE, col_names = FALSE, 
                trim_ws = TRUE, skip = 2)

  # "couper" le fichier à la fin de l'étape de définition des formats. elle se termine par un "run;" (le point virgule disparaît dans l'opération précédente).
stop <- which(formats$X1=="run")[1] - 1
stop

formats <- formats[1:stop,]

## transformer en un tableau contenant nom de variable, valeur du label et label ----
# ça peut varier selon la façon dont les formats sont écrits dans le fichier pour SAS

  # nettoyer la colonne des noms de variable : enlever le code avant et le f à la fin des noms
formats$var <- formats$X2 %>% 
  str_sub( start = 9L, end = -2L) 

    # recopier vers le bas pour toutes les lignes de chaque var
formats <- formats %>%   fill(var, .direction="down")

  # valeurs et labels : séparer en 2 colonnes, enlever les " et le =; nettoyage
formats <- formats  %>% 
  filter(!is.na(X1))   %>% 
  separate(X1, sep = "\"=\"", into= c("val", "val_lab")) %>% 
  select(-X2)  %>%  as_tibble


  ## pour les variables numériques dans le fichier sas ----

formats_num  <- formats %>%  filter(var  %in% list_num) %>% 
  mutate(val = as.numeric(val))

formats_char <- formats %>%  filter(var  %in% list_char) %>% 
  mutate(val = as.character(val))




 
## transformer en une liste de named vectors ----
  # faire une liste de dataframes, un par variable

valuelist_num <- formats_num %>% group_split(var) 
names(valuelist_num) <- formats_num %>% group_keys(var) %>% pull(var)


######## MODIF de Ida ################

# jenleve ce label tout court, sinon j'ai un doublon apres et ca bug 
#label_datdip <- which(names(valuelist_num) == "DATDIP_C_1")
#valuelist_num <- valuelist_num[-label_datdip];

# pour les autres variables concernées: 

# Identifier les index des variables concernées 
varsC_1 <- which(str_detect(names(valuelist_num),"_C_1"))

# Enlever la chaine de caracteres _C_1
for (n in varsC_1){
  names(valuelist_num)[n] <- str_remove(names(valuelist_num)[n],"_C_1") 
}
######################################

  # chaque item de la liste a pour nom le nom de la variable
 #names(valuelist) <- formats %>%   group_by(var) %>% nest %>% pull(var) 

  # transformer le dataframe en liste de named-vectors
valuelist_num <- sapply(valuelist_num, function(x) {x %>% select(val_lab, val) %>% deframe})

  # idem pour les vars charactère

valuelist_char <- formats_char %>% group_split(var) 
names(valuelist_char) <- formats_char %>% group_keys(var) %>% pull(var)

# chaque item de la liste a pour nom le nom de la variable
#names(valuelist) <- formats %>%   group_by(var) %>% nest %>% pull(var) 

# transformer le dataframe en liste de named-vectors
valuelist_char <- sapply(valuelist_char, function(x) {x %>% select(val_lab, val) %>% deframe})

valuelist <- append(valuelist_char, valuelist_num)


## appliquer les labels aux variables numériques dans le fichier de data----

val_labels(PC18) <- valuelist

## optionnel: convertir les données labelled on factors ----

PC18 <- to_factor(PC18)
# on peut conserver le numéro des modalités avec l'option : levels = "prefixed"
# l'ordre des modalités est conservé

## sauver dans un objet R ----

saveRDS(PC18, "data/PC18_avec_labels.RDS")

## on peut regarder les stats desc comme ceci ----
# je garde seulement les vars du début

PC18 %>%  select(POND:CSTOT) %>%  gtsummary::tbl_summary()

