import requests
import markdown2
import json

def fetch_markdown_from_github(github_url):
    response = requests.get(github_url)
    if response.status_code == 200:
        return response.text
    else:
        raise Exception(f"Failed to fetch Markdown from GitHub. Status code: {response.status_code}")

def markdown_to_json(md_content, json_file_path):
    # Convertir le contenu Markdown en HTML
    html_content = markdown2.markdown(md_content)

    # Organiser les données dans une structure JSON
    changelog_data = {}

    current_version = None
    for line in html_content.split('\n'):
        if line.startswith("<h2>"):
            current_version = line.replace("<h2>", "").replace("</h2>", "").strip()
            changelog_data[current_version] = []
        elif line.startswith("<li>"):
            cleaned_line = line.replace("<li>", "").replace("</li>", "").replace("<strong>", "").replace("</strong>", "").replace("<p>", "").replace("</p>", "").replace("*", "").strip()
            changelog_data[current_version].append(cleaned_line)

    # Écrire les données dans un fichier JSON
    with open(json_file_path, 'w', encoding='utf-8') as json_file:
        json.dump(changelog_data, json_file, ensure_ascii=False, indent=2)

# Exemple d'utilisation avec l'URL GitHub
github_markdown_url = 'https://raw.githubusercontent.com/V-o-x-a-r-y/Aizan-Version/main/CHANGELOG'
json_file_path = 'changelog.json'

markdown_content = fetch_markdown_from_github(github_markdown_url)
markdown_to_json(markdown_content, json_file_path)
