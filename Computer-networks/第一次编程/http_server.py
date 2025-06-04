import socket
import os
from datetime import datetime

def handle_request(connection):
    # 接收客户端发送的HTTP请求
    request = connection.recv(1024).decode()

    # 解析请求，获取请求的文件名
    file_name = request.split()[1]
    file_name = file_name[1:]

    # 检查文件是否存在
    if os.path.isfile(file_name):
        # 如果文件存在，读取文件内容
        with open(file_name, 'rb') as file:
            content = file.read()

        # 构造HTTP响应头部信息
        response_header = "HTTP/1.1 200 OK\r\n"
        response_header += f"Date: {datetime.now().strftime('%a, %d %b %Y %H:%M:%S GMT')}\r\n"
        response_header += "Server: MyServer\r\n"
        response_header += f"Content-Length: {len(content)}\r\n"
        response_header += "Content-Type: text/html; charset=UTF-8\r\n"
        response_header += "Cache-Control: no-cache\r\n"
        response_header += "Set-Cookie: session_id=12345; Expires=Wed, 04 Nov 2023 16:17:44 GMT\r\n"
        response_header += "\r\n"

        # 构造完整的HTTP响应消息
        response = response_header.encode() + content
    else:
        # 如果文件不存在，返回404错误消息
        response_header = "HTTP/1.1 404 Not Found\r\n\r\n"
        response = response_header.encode() + b"File not found."

    # 发送响应消息给客户端
    connection.sendall(response)

    # 关闭连接
    connection.close()


def run_server():
    # 创建套接字
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 绑定地址和端口
    server_address = ('', 13333)
    server_socket.bind(server_address)

    # 监听连接
    server_socket.listen(1)

    print('Server is running...')

    while True:
        # 接受客户端连接
        connection, client_address = server_socket.accept()
        print("Received connection from:", client_address)
        # 处理请求
        handle_request(connection)


run_server()



