import os
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

SCOPES = ['https://www.googleapis.com/auth/drive.file']

def list_files():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    token_path = os.path.join(script_dir, 'token.json')
    log_path = os.path.join(script_dir, 'links.txt')
    
    creds = Credentials.from_authorized_user_file(token_path, SCOPES)
    service = build('drive', 'v3', credentials=creds)

    results = service.files().list(pageSize=5, fields="files(id, name, webViewLink)").execute()
    items = results.get('files', [])

    with open(log_path, 'w', encoding='utf-8') as f:
        for item in items:
            f.write(f"NAME: {item['name']}\n")
            f.write(f"LINK: {item['webViewLink']}\n")
            f.write("-" * 20 + "\n")

if __name__ == '__main__':
    list_files()
