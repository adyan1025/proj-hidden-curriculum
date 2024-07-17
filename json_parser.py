import json
import csv

with open('history.json', 'r') as f:
    browser_history = json.load(f)
csv_file = "tiktoks_v3.csv"

index = 0
with open(csv_file, mode='w', newline='') as file:
    writer = csv.writer(file)
    writer.writerow(['Index', 'Link'])
    for browser_data in browser_history["Browser History"]:
        url = str(browser_data["url"])
        if "video" in url:
            index = index + 1
            writer.writerow([index, url])