import matplotlib.pyplot as plt

def find_friends(array):
    # Create a dictionary to store each person's friends
    friends_dict = {}

    # Iterate through each person in the array
    for name, position in array:
        # Calculate absolute differences between current person's position and others
        absolute_diff = [(other_name, abs(other_position - position)) for other_name, other_position in array if
                         other_name != name]

        # Sort the absolute differences based on position differences
        absolute_diff.sort(key=lambda x: x[1])

        # Take the first 5 elements (closest positions)
        closest_friends = [friend[0] for friend in absolute_diff[:5]]

        # Store the closest friends in the dictionary
        friends_dict[name] = closest_friends

    return friends_dict

# Example usage
individuals = [("Alice", 10), ("Bob", 15), ("Charlie", 5), ("David", 20), ("Eve", 25),("Amy",12),("Laoda",14),("Meisii",4)]
result = find_friends(individuals)
print(result)

# Visualization
names = [individual[0] for individual in individuals]
positions = [individual[1] for individual in individuals]

plt.figure(figsize=(12, 8))

# Plot each individual and their friends
for idx, (name, position) in enumerate(zip(names, positions)):
    plt.plot([position] * 6, [idx] * 6, 'bo')  # Plot individual
    plt.text(position, idx, name, ha='center', va='bottom', fontsize=8)  # Add name label
    friends = result[name]
    for friend in friends:
        friend_position = [individual[1] for individual in individuals if individual[0] == friend][0]
        plt.plot([position, friend_position], [idx, names.index(friend)], 'r-', alpha=0.5)  # Connect individual to friend

plt.xlabel('Position')
plt.ylabel('Individuals')
plt.title('Visualization of Closest Friends (Tree-like Structure)')
plt.grid(True)
plt.show()


