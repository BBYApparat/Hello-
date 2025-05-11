import os
import time
import requests
import pdfkit
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options

# Set up Selenium WebDriver
chrome_options = Options()
chrome_options.add_argument("--headless")  # Run without opening a browser
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("--no-sandbox")
chrome_driver_path = "path/to/chromedriver"  # Update this path

service = Service(chrome_driver_path)
driver = webdriver.Chrome(service=service, options=chrome_options)

BASE_URL = "https://veracityroleplay.gitbook.io/blaine-county-sheriffs-office-sop"
OUTPUT_FOLDER = "GitBook_SOP"

# Ensure output directory exists
os.makedirs(OUTPUT_FOLDER, exist_ok=True)

# Step 1: Get all page URLs from the sidebar
driver.get(BASE_URL)
time.sleep(3)  # Wait for JavaScript to load

page_links = []
elements = driver.find_elements(By.XPATH, '//a[@class="group"]')  # Adjust selector if needed

for elem in elements:
    url = elem.get_attribute("href")
    if url and url.startswith(BASE_URL):
        page_links.append(url)

driver.quit()  # Close Selenium WebDriver

print(f"Found {len(page_links)} pages to scrape.")

# Step 2: Scrape content from each page
for idx, url in enumerate(page_links, start=1):
    print(f"Scraping page {idx}/{len(page_links)}: {url}")
    
    response = requests.get(url, headers={"User-Agent": "Mozilla/5.0"})
    
    if response.status_code == 200:
        soup = BeautifulSoup(response.text, "html.parser")
        content = soup.find("article")  # Adjust selector if needed
        
        if content:
            text_content = content.get_text()
            filename = f"{OUTPUT_FOLDER}/Page_{idx}.txt"
            
            with open(filename, "w", encoding="utf-8") as file:
                file.write(text_content)
            
            print(f"Saved: {filename}")
        else:
            print(f"Skipping {url} (No content found)")
    else:
        print(f"Failed to fetch {url}, Status Code: {response.status_code}")

print("Scraping completed!")

# Step 3: Convert to PDF (Optional)
pdf_output = f"{OUTPUT_FOLDER}/Blaine_County_SOP.pdf"
pdfkit.from_file([f"{OUTPUT_FOLDER}/Page_{i}.txt" for i in range(1, len(page_links) + 1)], pdf_output)

print(f"PDF saved: {pdf_output}")
