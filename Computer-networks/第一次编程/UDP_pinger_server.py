import socket

server_ip = '172.30.42.45'  # 用实际的服务器IP地址替换
server_port = 14442  # 用实际的服务器端口替换

# 创建UDP socket
server_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
# 绑定服务器IP和端口
server_socket.bind((server_ip, server_port))

print(f'Server listening on {server_ip}:{server_port}')

while True:
    # 接收客户端消息和客户端地址
    message, client_address = server_socket.recvfrom(1024)
    print(f'Received message from {client_address[0]}: {message.decode()}')

    # 构造pong消息
    pong_message = f'Pong {message.decode()}'

    # 发送pong消息给客户端
    server_socket.sendto(pong_message.encode(), client_address)
    print(f'Sent pong message to {client_address[0]}')

# 关闭socket
server_socket.close()



