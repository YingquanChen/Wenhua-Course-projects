import numpy as np
import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, classification_report, confusion_matrix
from sklearn.decomposition import PCA
import matplotlib.pyplot as plt
from matplotlib.colors import ListedColormap
import seaborn as sns
# Define feature names
names = ['area', 'perimeter', 'compactness', 'length_of_kernel', 'width_of_kernel', 'asymmetry_coefficient',
         'length_of_kernel_groove', 'target']

# 1. Data Loading
dataset = pd.read_csv("E:\\Grade_two\\Machine_learninhg\\Task 2\\seeds\\seeds_dataset.txt", delimiter="\s+", names=names)

# 2. Data Preprocessing (if necessary)
# No preprocessing needed for this example

# 3. Split Data
X = dataset.drop('target', axis=1)
y = dataset['target']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.1, random_state=42)

# 4. Model Training
svm = SVC(kernel='linear', random_state=42)
svm.fit(X_train, y_train)

# 5. Model Evaluation
y_pred = svm.predict(X_test)
accuracy = accuracy_score(y_test, y_pred)
print("Accuracy:", accuracy)
print("\nClassification Report:\n")
print(classification_report(y_test, y_pred))

# 6. Dimensionality reduction for visualization (if necessary)
# For visualization purposes, we'll use PCA to project the data to 2D
pca = PCA(n_components=2)
X_train_pca = pca.fit_transform(X_train)
X_test_pca = pca.transform(X_test)

# 查看每个主成分是如何由原始特征构成的
print("第一主成分的构成: ", pca.components_[0])
print("第二主成分的构成: ", pca.components_[1])


# Train the SVM on the transformed data
svm.fit(X_train_pca, y_train)

# 7. Visualization - Decision Boundary
def plot_decision_boundary(X, y, classifier, test_idx=None, resolution=0.02):
    # Setup marker generator and color map
    markers = ('s', 'x', 'o', '^', 'v')
    colors = ('red', 'blue', 'lightgreen', 'gray', 'cyan')
    cmap = ListedColormap(colors[:len(np.unique(y))])

    # Plot the decision surface
    x1_min, x1_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    x2_min, x2_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    xx1, xx2 = np.meshgrid(np.arange(x1_min, x1_max, resolution),
                           np.arange(x2_min, x2_max, resolution))
    Z = classifier.predict(np.array([xx1.ravel(), xx2.ravel()]).T)
    Z = Z.reshape(xx1.shape)
    plt.contourf(xx1, xx2, Z, alpha=0.8, cmap=cmap)
    plt.xlim(xx1.min(), xx1.max())
    plt.ylim(xx2.min(), xx2.max())

    # Plot class samples
    for idx, cl in enumerate(np.unique(y)):
        plt.scatter(x=X[y == cl, 0], y=X[y == cl, 1],
                    alpha=0.8, c=cmap(idx),
                    marker=markers[idx], label=cl)

# 8. Plot the SVM decision boundary
plot_decision_boundary(X_train_pca, y_train, classifier=svm)
plt.xlabel('PCA Feature 1')
plt.ylabel('PCA Feature 2')
plt.legend(loc='upper left')
plt.title('SVM Decision Boundary')
plt.show()

# Visualization - Confusion Matrix
conf_matrix = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(8, 6))
sns.heatmap(conf_matrix, annot=True, fmt='d', cmap='Blues', cbar=False,
            xticklabels=np.unique(y), yticklabels=np.unique(y))
plt.xlabel('Predicted labels')
plt.ylabel('True labels')
plt.title('Confusion Matrix')
plt.show()