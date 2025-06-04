import socket
import time

# 创建一个UDP套接字对象
client_socket = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
server_address = ('172.30.42.45', 13546)

#设置请求得到数据包的总数
num_packets = 10
timeout = 1  # 设置超时的时间为1s，因为是在短途局部，一般不会这么高，而且大数量模拟0.5丢包，故设短点

#利用time库记录发送的初始时间，以便计算总时间
start_time = time.time()

packets_lost = 0  # 初始化丢失的包的总数

for packet_number in range(1, num_packets + 1):
    message = f"Packet {packet_number}"

    while True:
        # 向服务器端发送请求
        client_socket.sendto(message.encode(), server_address)

        # 为下一次得到数据包设置超时时间
        client_socket.settimeout(timeout)

        try:
            ack, _ = client_socket.recvfrom(1024)
            if ack == b"ACK":
                print(f"Received ACK for {message}")
                break  # 移动到下一个数据包的接收
        except socket.timeout:
            packets_lost += 1  # 如果接收超时，则丢失的包加一
            print(f"Timeout on {message}. Retransmitting...")
            continue # 跳出并准备再次接收

end_time = time.time()

#计算消耗的总时间
time_spent = end_time - start_time

packet_loss_rate = packets_lost / (num_packets+packets_lost) if num_packets > 0 else 0  # 计算丢包率

# 计算平均传输时间 (RTT)
average_rtt = time_spent / num_packets if num_packets > 0 else 0

print(f"Total packets sent: {num_packets+packets_lost}")
print(f"Packets lost: {packets_lost}")
print(f"Packet loss rate: {packet_loss_rate}")
print(f"Total time spent: {time_spent} seconds")
print(f"Average RTT: {average_rtt} seconds")

