#!/usr/bin/env python
# coding: utf-8

# In[1]:


import os,shutil


# In[2]:


path=r"/Users/maziarnamdar/Desktop/"


# In[3]:


file_name=os.listdir(path)


# In[4]:


folder_names=['PDF files','docx files']
for loop in range (0,2):
    if not os.path.exists(path + folder_names[loop]):
        os.makedirs(path + folder_names[loop])


# In[5]:


for file in file_name:
    if '.pdf' in file and not os.path.exists(path + 'PDF files/'+file):
        shutil.move(path +file,path + 'PDF files/'+file)


# In[6]:


for file in file_name:
    if '.docx' in file and not os.path.exists(path + 'docx files/'+file):
        shutil.move(path +file,path + 'docx files/'+file)

