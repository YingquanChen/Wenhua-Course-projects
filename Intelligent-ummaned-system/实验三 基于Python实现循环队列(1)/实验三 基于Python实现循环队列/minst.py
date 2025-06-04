import numpy as np
import struct
import time
import threading
import cv2
from collections import deque


# 图像类，用于存储单个图像的索引和数据
class MNISTImage:
    def __init__(self, index, data):
        self.index = index  # 图像索引
        self.data = data    # 图像数据


# 数据集类，用于加载MNIST图像数据集
class MNISTDataset:
    def __init__(self, file_path):
        self.images = []  # 存储加载的图像
        self.load_images(file_path)  # 调用加载函数

    def load_images(self, file_path):
        with open(file_path, 'rb') as f:  # 以二进制模式打开文件
            magic, num_images, num_rows, num_cols = struct.unpack('>IIII', f.read(16))
            # 读取文件头信息
            print(f"Magic Number: {magic}, Number of Images: {num_images}, Image Size: {num_rows}x{num_cols}")

            for index in range(1000):  # 读取最多1000幅图像
                img_data = f.read(28 * 28)  # 读取28x28的图像数据
                if not img_data:
                    break  # 如果没有数据，则退出
                image_array = np.frombuffer(img_data, dtype=np.uint8)  # 将数据转换为数组
                self.images.append(MNISTImage(index, image_array))  # 添加到图像列表


# 循环队列类，用于管理图像的缓存
class CircularQueue:
    def __init__(self, max_size):
        self.queue = deque(maxlen=max_size)  # 创建一个固定大小的双端队列
        self.lock = threading.Lock()  # 创建一个锁以确保线程安全

    def enqueue(self, item):
        with self.lock:  # 加锁以确保线程安全
            self.queue.append(item)  # 将项添加到队列

    def dequeue(self):
        with self.lock:  # 加锁以确保线程安全
            if self.queue:
                return self.queue.popleft()  # 移除并返回队列头部的项
            return None

    def is_full(self):
        return len(self.queue) == self.queue.maxlen  # 检查队列是否满

    def is_empty(self):
        return len(self.queue) == 0  # 检查队列是否空

    def size(self):
        return len(self.queue)  # 返回当前队列大小

    def maxlen(self):
        return self.queue.maxlen  # 返回队列的最大长度


# 输入输出管理类，用于处理图像的输入和显示
class ImageDisplay:
    def __init__(self, queue, mnist_dataset):
        self.queue = queue  # 保存队列
        self.read_frequency = 2  # 初始读取频率为2Hz
        self.mnist_dataset = mnist_dataset  # 保存数据集
        self.input_thread = threading.Thread(target=self.input_images)  # 创建输入线程
        self.input_thread.start()  # 启动输入线程

    def input_images(self):
        for image in self.mnist_dataset.images:
            while self.queue.is_full():
                time.sleep(0.1)  # 等待直到队列有空间
            self.queue.enqueue(image)  # 将图像放入队列
            time.sleep(0.25)  # 设置输入频率为4Hz

    def display_images(self):
        cv2.namedWindow('MNIST Images', cv2.WINDOW_NORMAL)  # 创建一个窗口
        while True:
            if not self.queue.is_empty():
                image = self.queue.dequeue()  # 从队列中取出图像
                img = image.data.reshape(28, 28)  # 将数据转换为图像格式
                cv2.imshow('MNIST Images', img)  # 显示图像

                # 显示队列状态
                print(f"Current queue size: {self.queue.size()}/{self.queue.maxlen()}")

                time.sleep(1 / self.read_frequency)  # 控制显示频率

                # 等待键盘输入，确保窗口更新
                if cv2.waitKey(1) & 0xFF == ord('q'):
                    break  # 按 'q' 键退出

            # 根据队列状态调整读取频率
            if self.queue.is_empty() and self.read_frequency == 8:
                self.read_frequency = 2  # 降低回2Hz
                print("Queue is empty, decreasing read frequency to 2Hz.")
            elif self.queue.is_full() and self.read_frequency == 2:
                self.read_frequency = 8  # 提升到8Hz
                print("Queue is full, increasing read frequency to 8Hz.")


# 主程序
if __name__ == "__main__":
    # 加载数据集，替换为实际的MNIST文件路径
    mnist_dataset = MNISTDataset("E:\Grade3\智能\实验三 基于Python实现循环队列(1)\实验三 基于Python实现循环队列\minst_images")
    queue = CircularQueue(max_size=40)  # 创建一个最大大小为40的循环队列
    display_manager = ImageDisplay(queue, mnist_dataset)  # 创建显示管理对象

    # 在主线程中调用显示函数
    display_manager.display_images()

    # 释放 OpenCV 窗口
    cv2.destroyAllWindows()
