# PC2018-Stage-R
Explorer l'enquête Pratiques Culturelles 2018 pour le stage de rentrée du master QESS.

Ce projet contient du matériel pour le Stage d'analyse secondaire des M1 du  [master Quantifier en sciences sociales](https://master-sciences-sociales.ens.psl.eu/qess-presentation/), en 2022-23.

## Préparer le projet

### Obtenir les données de l'ADISP : https://data.progedo.fr/studies/doi/10.13144/lil-1511

- enrôlement
- demande des données Pratiques culturelles 2018
- attendre
- télécharger les données au format SAS : 
  - `pc18_quetelet.sas7bdat`
  - `Format_lil-1511_SAS.txt`

### Préparer le projet 

- Créer un projet R (le mien s'appelle `PC2018-stage-R`).
- Dans le dossier racine du projet, créer un dossier `data/`. 
- Placer dans `data/`  les  données téléchargées
- télécharger le fichier `01_IMPORT.R` et le placer dans le dossier racine du projet.
- exécuter  `01_IMPORT.R`.
- Dans le dossier  `data/` on doit trouver un nouveau fichier `PC18_avec_labels.RDS`, dans lequel les variables catégorielles sont des facteurs.


Si on préfère travailler avec des nombres plutôt qu'avec l'intitulé des modalités (pendant les recodages par exemple) il est possible de modifier le fichier `01_IMPORT.R`.