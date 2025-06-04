import socket

server_ip = '172.30.42.45'   # 用实际的服务器ip地址替换
server_port = 15555  # 用实际的服务器端口替换
file_name = input("Please input the name of the file you want: ") #获取到需要的文件名

client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)  #创建套接字
client_socket.connect((server_ip, server_port))

#将文件名发送到服务器
client_socket.send(file_name.encode())
print(f"Sent file request: {file_name}")

#接收文件或者来自服务器的错误信息
response = client_socket.recv(1024)

if response.decode() == "File not found":  #如果没有该文件，则报404
    print("File not found on the server")
else:
    with open(file_name, 'wb') as file:     #有文件则输出
        file.write(response)
    print(f"File {file_name} received successfully")

client_socket.close()
