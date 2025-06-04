def bellman_ford(graph, source):
    # 初始化距离向量和前驱节点向量
    distances = {node: float('inf') for node in graph}
    distances[source] = 0
    predecessors = {node: None for node in graph}

    # 进行 |V| - 1 次松弛操作
    for _ in range(len(graph) - 1):
        for node in graph:
            for neighbor, weight in graph[node].items():
                # 松弛操作：如果通过当前节点到达邻居节点的路径比已知路径短，则更新距离和前驱节点
                if distances[node] + weight < distances[neighbor]:
                    distances[neighbor] = distances[node] + weight
                    predecessors[neighbor] = node

    # 检查是否存在负权回路
    for node in graph:
        for neighbor, weight in graph[node].items():
            # 如果仍然存在更短路径，则图中存在负权回路
            if distances[node] + weight < distances[neighbor]:
                raise ValueError("图中存在负权回路")

    return distances, predecessors

# 构建网络拓扑图
network = {
    0: {1: 1, 3: 6},
    1: {0: 1, 2: 3, 3: 4},
    2: {4: 6},
    3: {0: 6, 1: 4, 2: 2, 4: 9, 5: 2},
    4: {2: 6, 3: 9},
    5: {3: 2}
}

for start_node in network:
    distances, predecessors = bellman_ford(network, start_node)

    for node, distance in distances.items():
        if node != start_node:
            path = []
            current_node = node
            while current_node is not None:
                path.insert(0, current_node)
                current_node = predecessors[current_node]

            print(f"从节点 {start_node} 到 {node} 的路径: {path}, 距离: {distance}")






