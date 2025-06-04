import numpy as np
import matplotlib.pyplot as plt
from sklearn.datasets import make_moons, make_circles, make_blobs
from sklearn.cluster import KMeans, DBSCAN
from sklearn.preprocessing import StandardScaler


# Function to load dataset from file
def load_dataset(filename):
    data = np.loadtxt(filename)
    return data


# Function to visualize scatterplots
def visualize_dataset(X, title):
    plt.figure(figsize=(8, 6))
    plt.scatter(X[:, 0], X[:, 1], c='b', s=20, edgecolor='k')
    plt.title("The scatterplots of "+ title)
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.show()


# Function to apply K-means clustering and visualize results
def kmeans_clustering(X, n_clusters, title):
    kmeans = KMeans(n_clusters=n_clusters,n_init=10)
    kmeans.fit(X)
    labels = kmeans.labels_

    plt.figure(figsize=(8, 6))
    plt.scatter(X[:, 0], X[:, 1], c=labels, s=20, cmap='viridis', edgecolor='k')
    plt.title(f'K-means Clustering ({title})')
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.colorbar(label='Cluster')
    plt.show()


# Function to apply DBSCAN clustering and visualize results
def dbscan_clustering(X, eps, title):
    dbscan = DBSCAN(eps=eps)
    dbscan.fit(X)
    labels = dbscan.labels_

    plt.figure(figsize=(8, 6))
    plt.scatter(X[:, 0], X[:, 1], c=labels, s=20, cmap='viridis', edgecolor='k')
    plt.title(f'DBSCAN Clustering ({title})')
    plt.xlabel('Feature 1')
    plt.ylabel('Feature 2')
    plt.colorbar(label='Cluster')
    plt.show()


# Load datasets
datasets = ['noisy_circles.txt', 'noisy_moons.txt', 'blobs.txt', 'aniso.txt', 'no_structure.txt']
X_datasets = []
for dataset in datasets:
    X = load_dataset(dataset)
    X_datasets.append(X)

# Visualize datasets
for i, X in enumerate(X_datasets):
    visualize_dataset(X, datasets[i])

# Apply K-means clustering and visualize results
n_clusters = [2, 2, 3, 3, 3]
for i, X in enumerate(X_datasets):
    kmeans_clustering(X, n_clusters[i], datasets[i])

# Apply DBSCAN clustering and visualize results with different eps values
eps_values = [0.2, 0.3, 0.6, 0.5, 0.2 ] # Adjust eps values for each dataset
for i, X in enumerate(X_datasets):
    dbscan_clustering(X, eps_values[i], datasets[i])

