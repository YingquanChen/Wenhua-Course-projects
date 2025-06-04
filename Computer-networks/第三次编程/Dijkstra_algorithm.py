
import heapq
def dijkstra(graph, start):
    # 初始化节点到起始节点的距离，默认为无穷大
    distances = {node: float('inf') for node in graph}
    # 起始节点到自身的距离为0
    distances[start] = 0

    # 使用优先队列存储节点和对应的距离，起始节点入队
    priority_queue = [(0, start)]

    # 保存每个节点的前一个节点，用于还原最短路径
    previous_nodes = {node: None for node in graph}

    # 当优先队列不为空时循环
    while priority_queue:
        # 取出距离最短的节点及其距离
        current_distance, current_node = heapq.heappop(priority_queue)

        # 如果当前节点的距离大于已记录的距离，则忽略
        if current_distance > distances[current_node]:
            continue

        # 遍历当前节点的邻居
        for neighbor, weight in graph[current_node].items():
            # 计算从起始节点经过当前节点到达邻居节点的距离
            distance = current_distance + weight

            # 如果新的距离比已记录的距离小，则更新距离和前一个节点，并将邻居节点入队
            if distance < distances[neighbor]:
                distances[neighbor] = distance
                previous_nodes[neighbor] = current_node
                heapq.heappush(priority_queue, (distance, neighbor))

    # 返回计算得到的最短距离和前一个节点信息
    return distances, previous_nodes


# 构建网络拓扑图
network = {
    0: {1: 1, 3: 6},
    1: {0: 1, 2: 3, 3: 4},
    2: {4: 6},
    3: {0: 6, 1: 4, 2: 2, 4: 9, 5: 2},
    4: {2: 6, 3: 9},
    5: {3: 2}
}

# 对每个节点作为起始节点运行 Dijkstra 算法，输出最短路径和距离
for start_node in network:
    distances, previous_nodes = dijkstra(network, start_node)

    for node, distance in distances.items():
        # 打印最短路径和距离信息
        if node != start_node:
            path = []
            current_node = node
            while current_node is not None:
                path.insert(0, current_node)
                current_node = previous_nodes[current_node]

            print(f"从节点 {start_node} 到 {node} 的路径: {path}, 距离: {distance}")


