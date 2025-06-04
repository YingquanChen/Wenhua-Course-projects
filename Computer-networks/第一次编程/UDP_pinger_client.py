import socket
import time
import random

server_ip = '172.30.42.45'  # 用实际的服务器IP地址替换
server_port = 14442  # 用实际的服务器端口替换

client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)  #创建一个UDP socket
client_socket.settimeout(1)  # 设置超时时间为1秒

for sequence_number in range(1, 11):  #利用循环发送10条Ping消息到服务器
    message = f'Ping {sequence_number} {time.time()}'  #创建了一个包含序列号和时间戳的ping消息
    start_time = time.time()    #记录发送消息的起始时间

    # 模拟丢包，利用随机数
    if random.randint(1, 20) > 15:
        print(f'Packet {sequence_number} :lost')
        continue

    client_socket.sendto(message.encode(), (server_ip, server_port))  #不丢包时，成功发出，并计算rtt
    if random.randint(1, 20) < 15:
       try:
          response, server_address = client_socket.recvfrom(1024)
          end_time = time.time()
          rtt = end_time - start_time
          print(f'Packet {sequence_number}:Response from {server_address[0]}: {response.decode()}  RTT: {rtt:.6f} seconds')

       except socket.timeout:
          print(f'Request timed out for sequence number {sequence_number}')

    # 模拟丢包后的高延迟
    else :
           delay = random.uniform(2, 5)  # Random delay between 2 and 5 seconds
           print(f'Packet {sequence_number}: delay  {delay:.2f} seconds for lost packet {sequence_number}')
           time.sleep(delay)

client_socket.close()

