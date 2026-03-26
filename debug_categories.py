import requests

def check():
    url = "https://gsg-project-group-6.onrender.com/api/categories"
    try:
        r = requests.get(url)
        data = r.json()
        print("Categories on server:")
        for cat in data.get('data', {}).get('data', []):
            print(f"ID: {cat.get('id')}, Name: '{cat.get('name')}'")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    check()
