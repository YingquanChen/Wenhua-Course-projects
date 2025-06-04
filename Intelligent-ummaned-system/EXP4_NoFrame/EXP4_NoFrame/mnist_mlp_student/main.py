# 导入必要的库
import os  # 用于操作操作系统功能，如文件路径
import sys  # 用于访问与Python解释器紧密相关的变量和函数
import stu_upload.layers_1  # 导入自定义的神经网络层模块
from stu_upload.layers_1 import FullyConnectedLayer, ReLULayer, SoftmaxLossLayer  # 从模块中导入特定的层
from stu_upload.mnist_mlp_cpu import MNIST_MLP, build_mnist_mlp  # 导入MNIST数据集的MLP模型构建函数
import numpy as np  # 导入NumPy库，用于高效的数值计算
import struct  # 用于处理二进制数据
import time  # 用于时间相关的函数

# 定义一个评估函数，用于计算MLP模型在测试集上的准确率
def evaluate(mlp):
    # 初始化预测结果数组
    pred_results = np.zeros([mlp.test_data.shape[0]])
    # 遍历测试数据集，按批次进行预测
    for idx in range(int(mlp.test_data.shape[0]/mlp.batch_size)):
        # 获取当前批次的图像数据
        batch_images = mlp.test_data[idx*mlp.batch_size:(idx+1)*mlp.batch_size, :-1]
        # 通过MLP模型进行前向传播，获取概率
        prob = mlp.forward(batch_images)
        # 获取预测的标签
        pred_labels = np.argmax(prob, axis=1)
        # 将预测结果保存到数组中
        pred_results[idx*mlp.batch_size:(idx+1)*mlp.batch_size] = pred_labels
    # 如果测试数据集的最后一个批次大小小于batch_size，单独处理
    if mlp.test_data.shape[0] % mlp.batch_size > 0:
        last_batch = mlp.test_data.shape[0] // mlp.batch_size * mlp.batch_size
        # 获取最后一个批次的图像数据
        batch_images = mlp.test_data[-last_batch:, :-1]
        # 通过MLP模型进行前向传播，获取概率
        prob = mlp.forward(batch_images)
        # 获取预测的标签
        pred_labels = np.argmax(prob, axis=1)
        # 将预测结果保存到数组中
        pred_results[-last_batch:] = pred_labels
    # 计算准确率
    accuracy = np.mean(pred_results == mlp.test_data[:,-1])
    # 打印测试集上的准确率
    print('Accuracy in test set: %f' % accuracy)

# 如果这个脚本是作为主程序运行的
if __name__ == '__main__':
    # 构建MNIST数据集的MLP模型
    mlp = build_mnist_mlp()
    # 使用evaluate函数评估模型性能
    evaluate(mlp)