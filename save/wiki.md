# Gestion des Sauvegardes - Documentation

## Introduction
Ce script Python est conçu pour gérer la sauvegarde et la récupération de données dans une base de données MySQL. Il utilise la bibliothèque `cryptography` pour chiffrer les données avant de les stocker dans la base de données.

## Fonctions Principales

### `check_save_id_file(save_id_file_path)`
Vérifie l'existence du fichier `saveID.txt` qui contient l'ID actuel. Si le fichier existe, il lit l'ID, sinon il génère un nouvel ID, l'écrit dans le fichier et vérifie s'il existe déjà dans la base de données.

### `generate_save_id()`
Génère un ID aléatoire unique en s'assurant qu'il n'existe pas déjà dans la base de données.

### `check_id_exist(save_id)`
Vérifie si l'ID existe déjà dans la base de données.

### `get_save(save_id_file_path)`
Récupère et déchiffre les données associées à l'ID spécifié.

### `save_data(file_path)`
Chiffre et sauvegarde les données du fichier spécifié dans la base de données.

### `encrypt_data(data, key)`
Chiffre les données JSON avec la clé spécifiée.

### `decrypt_data(encrypted_data, key)`
Déchiffre les données avec la clé spécifiée.

## Utilisation

Le script peut être utilisé avec les options suivantes :

- `--getsave chemin/vers/le/fichier`: Récupère et affiche les données associées à l'ID stocké dans le fichier spécifié.
- `--save chemin/vers/le/fichier`: Chiffre et sauvegarde les données du fichier spécifié dans la base de données.

### Exemples d'utilisation

```bash
python script.py --getsave chemin/vers/le/fichier
python script.py --save chemin/vers/le/fichier
```
