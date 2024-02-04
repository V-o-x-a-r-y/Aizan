import os
import json
import mysql.connector
from cryptography.fernet import Fernet
import random
import sys

# Fonction pour vérifier l'existence du fichier saveID.txt
def check_save_id_file(save_id_file_path):
    if os.path.exists(save_id_file_path):
        with open(save_id_file_path, "r") as file:
            save_id = file.read().strip()
    else:
        save_id = generate_save_id()
        with open(save_id_file_path, "w") as file:
            file.write(save_id)
        # Effectuer la vérification si le fichier saveID.txt n'existe pas
        if check_id_exist(save_id):
            print(f"L'ID {save_id} existe déjà dans la base de données. Génération d'une nouvelle ID.")
            save_id = generate_save_id()
            print(f"Nouvelle ID générée : {save_id}")
            with open(save_id_file_path, "w") as file:
                file.write(save_id)
    return save_id

# Fonction pour générer un ID aléatoire unique
def generate_save_id():
    while True:
        save_id = str(random.randint(10**15, 10**16 - 1))
        if not check_id_exist(save_id):
            return save_id

# Fonction pour vérifier si l'ID existe dans la base de données
def check_id_exist(save_id):
    cursor.execute("SELECT ID FROM your_table WHERE ID = %s", (save_id,))
    return cursor.fetchone() is not None

# Option --getsave
def get_save(save_id_file_path):
    with open(save_id_file_path, "r") as file:
        save_id = file.read().strip()

    cursor.execute("SELECT JSON, `KEY` FROM your_table WHERE ID = %s", (save_id,))
    result = cursor.fetchone()
    if result:
        encrypted_data, key = result
        decrypted_data = decrypt_data(encrypted_data, key)
        return decrypted_data
    else:
        return -1


# Option --save
def save_data(file_path):
    save_id_file_path = "saveID.txt"

    if not os.path.exists(save_id_file_path):
        save_id = generate_save_id()
        with open(save_id_file_path, "w") as file:
            file.write(save_id)
        # Effectuer la vérification si le fichier saveID.txt n'existe pas
        if check_id_exist(save_id):
            print(f"L'ID {save_id} existe déjà dans la base de données. Génération d'une nouvelle ID.")
            save_id = generate_save_id()
            print(f"Nouvelle ID générée : {save_id}")
            with open(save_id_file_path, "w") as file:
                file.write(save_id)
    else:
        with open(save_id_file_path, "r") as file:
            save_id = file.read().strip()

    key = Fernet.generate_key()

    with open(file_path, "r") as file:
        json_data = json.load(file)

    encrypted_data = encrypt_data(json_data, key)

    try:
        cursor.execute("SELECT JSON FROM your_table WHERE ID = %s", (save_id,))
        existing_json = cursor.fetchone()

        if existing_json and existing_json[0] is not None:
            cursor.execute("UPDATE your_table SET JSON = %s, `KEY` = %s WHERE ID = %s", (encrypted_data, key, save_id))
            print("Sauvegarde existante mise à jour.")
        else:
            cursor.execute("INSERT INTO your_table (ID, JSON, `KEY`) VALUES (%s, %s, %s)", (save_id, encrypted_data, key))
            print("Nouvelle sauvegarde ajoutée.")

        db.commit()
    except Exception as e:
        db.rollback()
        print(f"Erreur lors de la sauvegarde : {e}")

# Fonction pour chiffrer les données
def encrypt_data(data, key):
    cipher = Fernet(key)
    encrypted_data = cipher.encrypt(json.dumps(data).encode())
    return encrypted_data

# Fonction pour déchiffrer les données
def decrypt_data(encrypted_data, key):
    cipher = Fernet(key)
    decrypted_data = cipher.decrypt(encrypted_data).decode()
    return json.loads(decrypted_data)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Utilisation : script.py [--getsave chemin/vers/le/fichier | --save chemin/vers/le/fichier]")
        sys.exit(1)

    db = mysql.connector.connect(
        host="YOUR HOST",
        user="YOUR  USER",
        password=" YOUR PASSWORD",
        database="YOUR DATABASE"
    )
    cursor = db.cursor()

    if sys.argv[1] == "--getsave":
        if len(sys.argv) == 3:
            save_id_file_path = sys.argv[2]
            result = get_save(save_id_file_path)
            print(result)
        else:
            print("Utilisation incorrecte : script.py --getsave chemin/vers/le/fichier")
    
    elif sys.argv[1] == "--save":
        if len(sys.argv) == 3:
            file_path = sys.argv[2]
            save_data(file_path)
        else:
            print("Utilisation incorrecte : script.py --save chemin/vers/le/fichier")

    cursor.close()
    db.close()
