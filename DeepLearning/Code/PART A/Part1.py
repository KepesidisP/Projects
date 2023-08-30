#!/usr/bin/env python
# coding: utf-8

# In[1]:


#pip install imbalanced-learn


# In[2]:


import pandas as pd
import numpy as np
from sklearn.model_selection import train_test_split
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.naive_bayes import GaussianNB
from sklearn.svm import SVC
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from sklearn.preprocessing import MinMaxScaler
import matplotlib.pyplot as plt


# In[3]:


# Read the dataset
data = pd.read_excel('Dataset2Use_PartA.xlsx')
data.head()


# In[4]:


data = data.drop('ΕΤΟΣ', axis=1)
data.head()


# In[5]:


#ros = RandomOverSampler(random_state=42)

# Perform random oversampling on your dataset
#X, y = ros.fit_resample(X, y)


# In[6]:


scaler = MinMaxScaler()
data_normalized = scaler.fit_transform(data)
data_normalized = pd.DataFrame(data_normalized, columns=data.columns)
data_normalized.shape


# In[7]:


data_normalized.head()


# In[8]:


models = [
    ('Linear Discriminant Analysis', LinearDiscriminantAnalysis()),
    ('Logistic Regression', LogisticRegression()),
    ('Decision Trees', DecisionTreeClassifier()),
    ('k-Nearest Neighbors', KNeighborsClassifier()),
    ('Naïve Bayes', GaussianNB()),
    ('Support Vector Machines', SVC()),
    ('Neural Networks', MLPClassifier())
]


# In[9]:


def model_fit(X,y):
    results = []
     
    for name, model in models:

        # Model fit
        model.fit(X_train, y_train)

        # Predict training data
        y_train_pred = model.predict(X_train)

        # Predict test data
        y_test_pred = model.predict(X_test)

        #0: healthy !!!
        #1: non-healthy !!!
        non_healthy_training_samples = sum(y_train == 1)
        TP = sum((y_train_pred == 0) & (y_train == 0))
        TN = sum((y_train_pred == 1) & (y_train == 1))
        FP = sum((y_train_pred == 1) & (y_train == 0))
        FN = sum((y_train_pred == 0) & (y_train == 1))
        precision = precision_score(y_train, y_train_pred, pos_label=0)
        recall = recall_score(y_train, y_train_pred, pos_label=0)
        f1 = f1_score(y_train, y_train_pred, pos_label=0)
        accuracy = accuracy_score(y_train, y_train_pred)
        TP_perc=TP/sum(y_train == 0)
        TN_perc=TN/sum(y_train == 1)

        success_rate_bankrupt = (TN/sum(y_train == 1))*100
        success_rate_non_bankrupt = (TP/sum(y_train == 0))*100


        # Save the results
        results.append([name, 'Training', len(X_train), non_healthy_training_samples, TP, TN, FP, FN, precision*100, recall*100, f1*100, accuracy*100, success_rate_bankrupt, success_rate_non_bankrupt])

        non_healthy_training_samples = sum(y_train == 1)
        TP = sum((y_test_pred == 0) & (y_test == 0))
        TN = sum((y_test_pred == 1) & (y_test == 1))
        FP = sum((y_test_pred == 0) & (y_test == 1))
        FN = sum((y_test_pred == 1) & (y_test == 0))
        precision = precision_score(y_test, y_test_pred, pos_label=0)
        recall = recall_score(y_test, y_test_pred, pos_label=0)
        f1 = f1_score(y_test, y_test_pred, pos_label=0)
        accuracy = accuracy_score(y_test, y_test_pred)
        TP_perc=TP/sum(y_test == 0)
        TN_perc=TN/sum(y_test == 1)

        success_rate_bankrupt = (TN/sum(y_test == 1))*100
        success_rate_non_bankrupt = (TP/sum(y_test == 0))*100

        results.append([name, 'Test', len(X_test), sum(y_test == 1), TP, TN, FP, FN, precision*100, recall*100, f1*100, accuracy*100, success_rate_bankrupt, success_rate_non_bankrupt])
    return results


# # Part 1

# In[10]:


# Split tou input X and output y
X = data_normalized[data_normalized.columns[:-1]].values
print(X.shape)


# In[11]:


y = data_normalized['ΕΝΔΕΙΞΗ ΑΣΥΝΕΠΕΙΑΣ (=2) (ν+1)']
len(y)


# In[12]:


# Data
classes = ['Healthy', 'Non-Healthy']
data_counts = [sum(y==0), sum(y==1)]

# Display bar chart
plt.bar(classes, data_counts)

# Set title and labels
plt.title('Αριθμός Στοιχείων ανά Κλάση')
plt.xlabel('Κλάσεις')
plt.ylabel('Αριθμός Στοιχείων')
#Save the chart as a PNG file
plt.savefig('graph1.png')
plt.show()


# In[13]:


# Διαχωρισμός σε training και test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
#0: healthy
#1: non-healthy


# In[14]:


results=model_fit(X,y)


# In[15]:


results_df = pd.DataFrame(results, columns=['Classifier Name', 'Training or test set', 'Number of samples', 'Number of non-healthy companies in training sample', 'TP', 'TN', 'FP', 'FN', 'Precision', 'Recall', 'F1 score', 'Accuracy', 'Success Rate (Bankrupt)', 'Success Rate (Non-Bankrupt)'])
results_df.to_excel('results_Part_A1.xlsx', index=False)
results_df


# # Part 2

# In[16]:


# Select all bankrupt samples
bankrupt_samples = data_normalized[data_normalized['ΕΝΔΕΙΞΗ ΑΣΥΝΕΠΕΙΑΣ (=2) (ν+1)'] == 1]
print("length of bankrupt businesses:",len(bankrupt_samples))

# Randomly select non-bankrupt samples
non_bankrupt_samples = data_normalized[data_normalized['ΕΝΔΕΙΞΗ ΑΣΥΝΕΠΕΙΑΣ (=2) (ν+1)'] == 0].sample(n=3*len(bankrupt_samples), random_state=42)
print("length of non-bankrupt businesses:",len(non_bankrupt_samples))

# Concatenate non-bankrupt and bankrupt samples
combined_data = pd.concat([non_bankrupt_samples, bankrupt_samples])
print("length of dataset:",len(combined_data))


# In[17]:


combined_data.shape


# In[18]:


# Split the combined data into features (X) and target variable (y)
X = combined_data[combined_data.columns[:-1]].values
y = combined_data['ΕΝΔΕΙΞΗ ΑΣΥΝΕΠΕΙΑΣ (=2) (ν+1)']


# In[19]:


# Data
classes = ['Healthy', 'Non-Healthy']
data_counts = [sum(y==0), sum(y==1)]

# Display bar chart
plt.bar(classes, data_counts)

# Set title and labels
plt.title('Αριθμός Στοιχείων ανά Κλάση')
plt.xlabel('Κλάσεις')
plt.ylabel('Αριθμός Στοιχείων')
#Save the chart as a PNG file
plt.savefig('graph2.png')
plt.show()


# In[20]:


# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)


# In[21]:


# Fit and evaluate models
results = model_fit(X, y)


# In[22]:


# Create a DataFrame with the results
results_df = pd.DataFrame(results, columns=['Classifier Name', 'Training or test set', 'Number of samples', 'Number of non-healthy companies in training sample', 'TP', 'TN', 'FP', 'FN', 'Precision', 'Recall', 'F1 score', 'Accuracy', 'Success Rate (Bankrupt)', 'Success Rate (Non-Bankrupt)'])
results_df.to_excel('results_Part_A2.xlsx', index=False)
results_df


# # Better suggestion

# In[23]:


# Perform random undersampling on your dataset

from imblearn.under_sampling import RandomUnderSampler

ros = RandomUnderSampler(random_state=0)
X = data_normalized[data_normalized.columns[:-1]].values
y = data_normalized['ΕΝΔΕΙΞΗ ΑΣΥΝΕΠΕΙΑΣ (=2) (ν+1)']

X, y = ros.fit_resample(X, y)
print(X.shape)
print(sum(y==1))
print(sum(y==0))


# In[24]:


# Data
classes = ['Healthy', 'Non-Healthy']
data_counts = [sum(y==0), sum(y==1)]

# Display bar chart
plt.bar(classes, data_counts)

# Set title and labels
plt.title('Αριθμός Στοιχείων ανά Κλάση')
plt.xlabel('Κλάσεις')
plt.ylabel('Αριθμός Στοιχείων')
#Save the chart as a PNG file
plt.savefig('graph3.png')
plt.show()


# In[25]:


# Split the data into training and test sets
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
# Fit and evaluate models
results = model_fit(X, y)


# In[26]:


# Create a DataFrame with the results
results_df = pd.DataFrame(results, columns=['Classifier Name', 'Training or test set', 'Number of samples', 'Number of non-healthy companies in training sample', 'TP', 'TN', 'FP', 'FN', 'Precision', 'Recall', 'F1 score', 'Accuracy', 'Success Rate (Bankrupt)', 'Success Rate (Non-Bankrupt)'])
results_df.to_excel('results_Part_A3.xlsx', index=False)
results_df


# In[ ]:




