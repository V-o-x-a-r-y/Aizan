# Changlog

## [Alpha 1.6.2](https://github.com/V-o-x-a-r-y/Aizan/releases/tag/v1.6.2-alpha) - 4 Février 2024

- Ajout de la syncronisation des sauvegarde sur une base de données MySQL. (Isaac)
- Ajout d'un script pout la récupération du changelog dans le jeu. (Isaac)
- Ajout d'un logiciel de mis à jours. (Isaac)
- Création d'un site internet [Aizan.Space](https://aizan.space).

### Save Script File

#### Version 1.0 : Code initial

Script de base pour enregistrer et récupérer des données JSON cryptées à l'aide de MySQL.
Implémente un système de génération d'identifiants simple.
Fournit une fonctionnalité pour vérifier si l’ID existe dans la base de données.
Utilise le cryptage Fernet pour sécuriser les données.

#### Version 1.1 : optimisation du code et corrections de bugs

Amélioration de la fonction check_save_id_file pour éliminer la redondance du code.
Amélioration de la fonction generate_save_id pour une meilleure lisibilité.
Correction d'un bug dans la fonction save_data où la vérification de l'identité était dupliquée.
Légères améliorations apportées à la structure du code pour une meilleure organisation.

#### Version 1.2 : amélioration de l'interface de ligne de commande

Modification de l'interface de ligne de commande pour fournir des instructions plus claires sur la façon d'utiliser le script.
Ajout de la gestion des erreurs en cas d'utilisation incorrecte de la ligne de commande.
Mise à jour du code pour utiliser plus efficacement les arguments de ligne de commande.
Introduction d'une sortie plus informative pour l'utilisateur lors de l'exécution du script.
