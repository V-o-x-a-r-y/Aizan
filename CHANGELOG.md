# Aizan - 相斬
## Save File
### Version 1.0.0 (Avant Chiffrement des Identifiants)

Code fonctionnel gérant la sauvegarde et la récupération de données depuis une base de données MySQL.
Utilise un fichier "saveID.txt" pour stocker un identifiant unique généré aléatoirement.

### Version 1.1.0 (Chiffrement des Identifiants)

Ajout du chiffrement des identifiants de base de données pour renforcer la sécurité.
Les identifiants (host, user, password, database) sont maintenant stockés dans un fichier chiffré "encrypted_creds.txt".
Utilisation de la bibliothèque Fernet pour le chiffrement et le déchiffrement des données sensibles.

### Version 1.1.1 (Modifications Mineures)

Correction de quelques commentaires et mise en forme du code pour améliorer la lisibilité.

###  Version 1.2.0 (Fonctionnalité Améliorée)

Ajout d'une fonction load_credentials() pour charger les identifiants depuis le fichier chiffré.
Amélioration de la fonction establish_database_connection() pour prendre en charge les identifiants chiffrés.

### Version 1.2.1 (Correction de Bugs)

Correction d'un bug lié à la gestion des fichiers binaires lors de la lecture des identifiants chiffrés.

### Version 1.3.0 (Sauvegarde Chiffrée)

Ajout du chiffrement des données avant de les stocker dans la base de données.
Les données sont chiffrées avec une clé générée aléatoirement pour chaque sauvegarde.
Amélioration de la sécurité globale du système.
Cela devrait vous donner une idée des modifications apportées à chaque version du code. N'oubliez pas d'ajuster les numéros de version en fonction de votre processus de gestion de versions spécifique.
