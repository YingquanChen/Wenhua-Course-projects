import socket
import os

server_ip = '172.30.42.45'  # 用实际的ip地址替换
server_port = 15555  # 用实际的服务器端口替换

# 创建TCP socket对象
server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# 将socket对象绑定到指定的IP地址和端口
server_socket.bind((server_ip, server_port))

# 开始监听连接，参数1指定最大连接数
server_socket.listen(1)

print(f"Server listening on {server_ip}:{server_port}")

while True:
    # 接受客户端的连接请求，并返回客户端的socket对象和地址
    client_socket, client_address = server_socket.accept()
    print(f"Connection established with {client_address[0]}:{client_address[1]}")

    # 从客户端接收文件名
    file_name = client_socket.recv(1024).decode()
    print(f"Received file request: {file_name}")

    if os.path.isfile(file_name):
        # 如果文件存在，发送文件内容给客户端
        with open(file_name, 'rb') as file:
            file_data = file.read()

        client_socket.send(file_data)
        print("File sent successfully")
    else:
        # 如果文件不存在，发送错误消息给客户端
        error_message = "File not found"
        client_socket.send(error_message.encode())
        print("File not found error sent")

    # 关闭与客户端的连接
    client_socket.close()

# 关闭服务器socket
server_socket.close()

