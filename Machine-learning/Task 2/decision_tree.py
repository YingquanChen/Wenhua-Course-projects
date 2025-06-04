import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
import matplotlib.pyplot as plt
from sklearn.tree import plot_tree
import seaborn as sns
# Define feature names
names = ['area', 'perimeter', 'compactness', 'length_of_kernel', 'width_of_kernel', 'asymmetry_coefficient',
         'length_of_kernel_groove', 'target']

# 1. Data Loading
dataset = pd.read_csv("E:\\Grade_two\\Machine_learninhg\\Task 2\\seeds\\seeds_dataset.txt", delimiter="\s+", names=names)

# 2. Split Data
X = dataset.drop('target', axis=1)
y = dataset['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=42)

# 3. Model Training
decision_tree = DecisionTreeClassifier()
decision_tree.fit(X_train, y_train)

# 4. Model Evaluation
y_pred = decision_tree.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)
print("\nClassification Report:")
print(classification_report(y_test, y_pred))

# 5. Visualization - Decision Boundary
# Decision boundaries are not easily visualized for high-dimensional data.
# Instead, we'll visualize the decision tree structure.

# 6. Visualization - Confusion Matrix
conf_matrix = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(8, 6))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', cbar=False,
            xticklabels=np.unique(y), yticklabels=np.unique(y))
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix')
plt.show()

# 7. Visualization - Decision Tree Structure
plt.figure(figsize=(15, 10))
plot_tree(decision_tree, feature_names=X.columns, class_names=np.unique(y).astype(str), filled=True)
plt.show()

