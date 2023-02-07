# MP le 07/02/2023
# --- exemple où âge et diplôme affectent une troisième variable ---

# j'ai volontairement mis beaucoup de commentaires et laissé les petits de tableaux avant et après recodage, à des fins pédagogiques.

# charger packages et data ----

library(questionr)
library(tidyverse)

#source("01_import.R") # si le fichier ci-dessous n'existe pas

PC18 <- readRDS("data/PC18_avec_labels.RDS")

# recodages ---


# ces petits tableaux me permettent de décider comment je vais recoder :
table(PC18$I4)
table(PC18$DIPLOM)
table( PC18$CRITAGE)


PC18$InternetTsLesJours <- (PC18$I4 == "Tous les jours ou presque")

## Recodage de PC18$DIPLOM en PC18$DIPLOM_rec
PC18$DIPLOM_rec <- PC18$DIPLOM %>%
  fct_recode(
    "Bas" = "Vous n'avez jamais été à l'école ou vous l'avez quittée avant la fin du primaire",
    "Bas" = "Aucun diplôme et scolarité interrompue à la fin du primaire ou avant la fin du collège",
    "Bas" = "Aucun diplôme et scolarité jusqu'à la fin du collège et au-delà",
    "Bas" = "CEP",
    "Bas" = "BEPC, brevet élémentaire, brevet des collèges, DNB",
    "Moyen" = "CAP, BEP ou diplôme équivalent",
    "Moyen" = "Baccalauréat général ou technologique, brevet supérieur",
    "Haut" = "Capacité en droit, DAEU, ESEU",
    "Moyen" = "Baccalauréat professionnel, brevet professionnel, de technicien ou d'enseignement, diplôme équivalent",
    "Haut" = "BTS, DUT, DEUST, diplôme de la santé ou social de niveau Bac+2 ou diplôme équivalent",
    "Haut" = "Licence, licence pro, maîtrise ou autre diplôme de niveau Bac+3 ou 4 ou diplôme équivalent",
    "Haut" = "Master, DEA, DESS, diplôme grande école de niveau Bac+5, doctorat de santé",
    "Haut" = "Doctorat de recherche (hors santé)",
    "Bas" = "NSP",
    "Bas" = "REF"
  )

# vérifier les recodages
table(PC18$I4, PC18$InternetTsLesJours )
table (PC18$DIPLOM, PC18$DIPLOM_rec)

# ==> il faudrait vérifier ce qu'est précisément une capacité en droit, il se peut que ce soit un dipl du Secondaire.

# tableaux bivariés ----

table(PC18$DIPLOM_rec, PC18$InternetTsLesJours) %>% lprop()

table( PC18$CRITAGE, PC18$DIPLOM_rec) %>% lprop()

table( PC18$CRITAGE, PC18$InternetTsLesJours) %>% lprop()


# comprendre comment les 2 variables affectent la proba de se connecter à internet tous les jours ----

# les tableaux à 3 variables ne sont pas pratiques dans R, un graphique est souvent plus parlant.
# Je commence par mettre en forme les données que je vais représenter graphiquement : pour ça il me faut la proportion de InternetTsLesJours == TRUE par catégorie d'âge et de diplôme.
# notez qu'ici c'est non pondéré et sans intervalle de confiance. 

PC18 %>% group_by(CRITAGE, DIPLOM_rec ) %>%  
              #indiquer comment les lignes seront regroupées
         summarise( mean = mean(InternetTsLesJours)) %>% 
              # calculer les moyennes. R comprend qu'il faut traiter TRUE comme 1 et FALSE comme 0
          ggplot( aes( x = CRITAGE, y = mean, group = DIPLOM_rec, color = DIPLOM_rec)  )+ geom_point( ) + geom_line()
              # graphique. notez l'usage de "group =" dans aes().

# entraînez-vous à commenter le graphique sous tous les angles : est-ce qu'il y a un lien entre âge quel que soit le niveau de diplôme? est-ce qu'il y a un lien entre diplôme et internet quel que soit l'âge? est-ce que l'effet du diplôme est plus fort pour certains groupes d'âge? et vice-versa.

# pour faire un tableau à trois variables: 

PC18 %>% group_by(CRITAGE, DIPLOM_rec ) %>%  
    #indiquer comment les lignes seront regroupées
  summarise( mean = mean(InternetTsLesJours) *100) %>% 
    # je calcule la moyenne, et je multiplie par 100 pour faciliter la lecture en %age
  pivot_wider(names_from = DIPLOM_rec, values_from = mean) 
    # je pivote.  
    # penser à donner un titre explicite, vérifier le nombre d'individus et l'indiquer sous le tableau.
  

  
                                                                                                                                                                
       