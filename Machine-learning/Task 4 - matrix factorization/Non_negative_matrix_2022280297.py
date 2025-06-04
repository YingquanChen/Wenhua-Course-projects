import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from sklearn.decomposition import NMF
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import MinMaxScaler

# Step 1: Load the dataset
df = pd.read_csv(r"E:\Grade_two\Machine_learninhg\Task 4 - matrix factorization\seeds.csv")

# Step 2: Extract the grain variety and the feature data
varieties = df.iloc[:, -1]  # Assuming the last column is the variety
features = df.iloc[:, :-1].values  # All columns except the last one

# Step 3: Scale the feature data to be non-negative
scaler = MinMaxScaler()
features_scaled = scaler.fit_transform(features)

# Initialize variables for storing the best results
best_silhouette_score = -1
best_clustering_result = None
silhouette_scores = []
all_clustering_results = []

# Step 4: Run NMF and calculate Silhouette coefficients
for i in range(20):
    nmf = NMF(n_components=3, init='random', random_state=i, max_iter=1000, beta_loss="frobenius")
    W = nmf.fit_transform(features_scaled)

    # Find the most relevant NMF component to which each sample belongs
    cluster_labels = np.argmax(W, axis=1)

    # Calculate Silhouette coefficient
    silhouette_avg = silhouette_score(features_scaled, cluster_labels)
    silhouette_scores.append(silhouette_avg)
    all_clustering_results.append(cluster_labels)

    # Update best score and clustering result
    if silhouette_avg > best_silhouette_score:
        best_silhouette_score = silhouette_avg
        best_clustering_result = cluster_labels

# Print the silhouette scores
print("\nSilhouette scores for each run:")
for idx, score in enumerate(silhouette_scores):
    print(f"Run {idx + 1}: {score:.3f}")

# Step 5: Plot Silhouette scores
plt.figure(figsize=(14, 8))
plt.plot(range(1, 21), silhouette_scores, marker='o', linestyle='-', color='b', label='Silhouette Score')
plt.title('Silhouette Scores for Different NMF Initializations')
plt.xlabel('Initialization Run')
plt.ylabel('Silhouette Score')
plt.scatter(np.argmax(silhouette_scores) + 1, best_silhouette_score, s=200, color='none', edgecolor='r', linewidth=2, label=f'Best Score: {best_silhouette_score:.3f}')
plt.legend()
plt.grid(True)
plt.xticks(range(1, 21))
plt.show()

# Step 6: Create a crosstab of the varieties and the best clustering results
best_clustering_df = pd.DataFrame({'Variety': varieties, 'Cluster': best_clustering_result})
crosstab = pd.crosstab(best_clustering_df['Variety'], best_clustering_df['Cluster'])

# Display the crosstab
print("\nCrosstab of varieties and best clustering results:")
print(crosstab)

# Step 7: Evaluate the best clustering result using Silhouette Score
print(f'\nBest Silhouette Score: {best_silhouette_score:.3f}')


