# data_preprocessing.py

import os
import cv2
import numpy as np

def prepare_dataset_cnn(data_dir):
    images = []
    labels = []
    
    # 读取数据集目录下的所有文件
    for filename in os.listdir(data_dir):
        if filename.endswith(".jpg"):
            image_path = os.path.join(data_dir, filename)
            txt_path = os.path.join(data_dir, filename.replace(".jpg", ".txt"))
            
            # 读取对应的标签文件
            with open(txt_path, 'r') as f:
                label = f.read().strip().split(',')[1].strip()  # 获取标签编号
            
            img = cv2.imread(image_path)
            img = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)  # 转换为灰度图
            img = cv2.resize(img, (100, 100))  # 统一大小
            images.append(img)  # 将处理后的图片加入列表
            labels.append(int(label))  # 标签转为整数
    
    return images, labels
