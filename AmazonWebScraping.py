#!/usr/bin/env python
# coding: utf-8

# In[2]:


# import libraries

from bs4 import BeautifulSoup
import requests
import smtplib
import time
import datetime


# In[51]:


# Connect to Website and pull in data

URL ='https://www.amazon.com/dp/B08PL51QC6/ref=sspa_dk_detail_2?ie=UTF8&pd_rd_i=B08PL51QC6p13NParams&s=apparel&sp_csd=d2lkZ2V0TmFtZT1zcF9kZXRhaWxfdGhlbWF0aWM&th=1&psc=1'
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

page = requests.get(URL, headers=headers)

soup1 = BeautifulSoup(page.content, "html.parser")

soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

title = soup2.find(id='productTitle').get_text()
price = soup2.find('span', attrs={'class':'a-price-whole'}).get_text()
price = price.strip()[:2]
print(title)
print(price)
                
           
           
           
           


# In[57]:


#date and time import
import datetime

today= datetime.date.today()

print(today)


# In[59]:


#opening a csv file to put data inside
import csv 

header = ['Title', 'Price','Date']
data = [title, price,today]


with open('AmazonWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(data)



# In[71]:


import pandas as pd
df=pd.read_csv(r'/Users/maziarnamdar/AmazonWebScraperDataset.csv')
print(df)


# In[67]:


def check_price():
    URL ='https://www.amazon.com/dp/B08PL51QC6/ref=sspa_dk_detail_2?ie=UTF8&pd_rd_i=B08PL51QC6p13NParams&s=apparel&sp_csd=d2lkZ2V0TmFtZT1zcF9kZXRhaWxfdGhlbWF0aWM&th=1&psc=1'
    headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

    page = requests.get(URL, headers=headers)

    soup1 = BeautifulSoup(page.content, "html.parser")

    soup2 = BeautifulSoup(soup1.prettify(), "html.parser")

    title = soup2.find(id='productTitle').get_text()
    price = soup2.find('span', attrs={'class':'a-price-whole'}).get_text()
    
    price = price.strip()[:2]
    
    import datetime

    today= datetime.date.today()

    print(today)
    import csv 

    header = ['Title', 'Price','Date']
    data = [title, price,today]


    with open('AmazonWebScraperDataset.csv', 'a+', newline='', encoding='UTF8') as f:
        writer = csv.writer(f)
        writer.writerow(data)
        


# In[70]:


while (True):
    check_price()
    time.sleep(86400)


# In[ ]:


#send an email if a price falls below a certain amount to notify.

def send_mail():
    server = smtplib.SMTP_SSL('smtp.gmail.com',465)
    server.ehlo()
    #server.starttls()
    server.ehlo()
    server.login('Khash.namdar@gmail.com','xxxxxxxxxxxxxx')
    
    subject = "The Shirt you want is below $15! Now is your chance to buy!"
    body = "Khash, This is the moment we have been waiting for. Now is your chance to pick up the shirt of your dreams. Don't mess it up! Link here: https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data+analyst+tshirt&qid=1626655184&sr=8-3"
   
    msg = f"Subject: {subject}\n\n{body}"
    
    server.sendmail(
        'Khash.namdar@gmail.com',
        msg
     
    )


# In[ ]:




