import os
from google.oauth2.credentials import Credentials
from googleapiclient.discovery import build

SCOPES = ['https://www.googleapis.com/auth/drive.file']

def list_files():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    token_path = os.path.join(script_dir, 'token.json')
    
    if not os.path.exists(token_path):
        print("Token not found.")
        return

    creds = Credentials.from_authorized_user_file(token_path, SCOPES)
    service = build('drive', 'v3', credentials=creds)

    results = service.files().list(
        pageSize=5, fields="nextPageToken, files(id, name, webViewLink)").execute()
    items = results.get('files', [])

    if not items:
        print('No files found.')
    else:
        print('Files:')
        for item in items:
            print(f"{item['name']} ({item['id']})")
            print(f"URL: {item['webViewLink']}")
            print("-" * 20)

if __name__ == '__main__':
    list_files()
