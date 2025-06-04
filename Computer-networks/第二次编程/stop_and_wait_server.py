import socket
import random


#创建一个UDP的套接字对象
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_socket.bind(('172.30.42.45', 13546))

# 设置丢包机制
LOSS_PROBABILITY = 0.2  # 设置为20%的丢包可能性

while True:
    message, client_address = server_socket.recvfrom(1024)

    # 模拟数据丢包过程
    if random.random() < LOSS_PROBABILITY:
        print(f"Packet loss on message: {message.decode()}")
        continue  # 跳过确认该数据包

    server_socket.sendto(b"ACK", client_address)  # 发送ack
