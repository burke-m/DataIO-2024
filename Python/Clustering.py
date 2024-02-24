import pandas as pd
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt

total = pd.read_csv('December.csv')

# Assuming 'latitude' and 'longitude' are the columns in your dataset
data = total[['start_lat', 'start_lng']]

# Scale the data
# You can use StandardScaler or MinMaxScaler from scikit-learn
from sklearn.preprocessing import StandardScaler
scaler = StandardScaler()
scaled_data = scaler.fit_transform(data)

# Determine the optimal number of clusters (k)
# Example using the elbow method
sse = []
for k in range(1, 50):
    kmeans = KMeans(n_clusters=k)
    kmeans.fit(scaled_data)
    sse.append(kmeans.inertia_)

# Plot the elbow curve
plt.plot(range(1, 50), sse, marker='o')
plt.xlabel('Number of clusters')
plt.ylabel('SSE')
plt.title('Elbow Method')
plt.show()

# Based on the elbow curve, choose the optimal number of clusters (k)

# Apply K-means clustering
kmeans = KMeans(n_clusters=50)  # Example: assuming 3 clusters
kmeans.fit(scaled_data)

# Add cluster labels to the dataset
data['cluster'] = kmeans.labels_

# Visualize the clusters
plt.scatter(data['start_lng'], data['start_lat'], c=data['cluster'], cmap='viridis')
plt.xlabel('Longitude')
plt.ylabel('Latitude')
plt.title('K-means Clustering')
plt.show()