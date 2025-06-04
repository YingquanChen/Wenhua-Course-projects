# coding=utf-8
import numpy as np
import struct
import os
import time


class FullyConnectedLayer(object):
    # 全连接层的初始化方法
    def __init__(self, num_input, num_output):
        self.num_input = num_input  # 输入节点数
        self.num_output = num_output  # 输出节点数
        print('\tFully connected layer with input %d, output %d.' % (self.num_input, self.num_output))

    # 参数初始化方法，使用正态分布初始化权重，偏置初始化为0
    def init_param(self, std=0.01):
        self.weight = np.random.normal(loc=0.0, scale=std, size=(self.num_input, self.num_output))
        self.bias = np.zeros([1, self.num_output])

    # 前向传播计算方法，计算全连接层的输出
    def forward(self, input):
        start_time = time.time()  # 记录前向传播开始时间
        self.input = input  # 保存输入数据
        # 计算全连接层的输出，使用矩阵乘法和偏置相加
        self.output = np.matmul(input, self.weight) + self.bias
        return self.output

    # 反向传播计算方法，计算全连接层的梯度
    def backward(self, top_diff):
        # 计算权重梯度和偏置梯度
        self.d_weight = np.dot(self.input.T, top_diff)
        self.d_bias = np.sum(top_diff, axis=0)
        # 计算下一层的梯度
        bottom_diff = np.dot(top_diff, self.weight.T)
        return bottom_diff

    # 参数更新方法，根据学习率更新权重和偏置
    def update_param(self, lr):
        self.weight = self.weight - lr * self.d_weight
        self.bias = self.bias - lr * self.d_bias

    # 参数加载方法，从外部加载权重和偏置
    def load_param(self, weight, bias):
        assert self.weight.shape == weight.shape
        assert self.bias.shape == bias.shape
        self.weight = weight
        self.bias = bias

    # 参数保存方法，保存当前的权重和偏置
    def save_param(self):
        return self.weight, self.bias


class ReLULayer(object):
    # ReLU层的初始化方法
    def __init__(self):
        print('\tReLU layer.')

    # ReLU层的前向传播计算方法，应用ReLU激活函数
    def forward(self, input):
        start_time = time.time()  # 记录前向传播开始时间
        self.input = input  # 保存输入数据
        output = np.maximum(0, input)  # 应用ReLU激活函数
        return output

    # ReLU层的反向传播计算方法，计算梯度
    def backward(self, top_diff):
        bottom_diff = top_diff.copy()  # 复制上层传回的梯度
        bottom_diff[self.input < 0] = 0  # ReLU的导数，当输入小于0时导数为0
        return bottom_diff


class SoftmaxLossLayer(object):
    # Softmax损失层的初始化方法
    def __init__(self):
        print('\tSoftmax loss layer.')

    # Softmax损失层的前向传播计算方法，计算概率分布
    def forward(self, input):
        input_max = np.max(input, axis=1, keepdims=True)  # 每行的最大值
        input_exp = np.exp(input - input_max)  # 计算指数
        self.prob = input_exp / np.sum(input_exp, axis=1, keepdims=True)  # 计算概率分布
        return self.prob

    # 计算损失的方法，使用交叉熵损失函数
    def get_loss(self, label):
        self.batch_size = self.prob.shape[0]  # 获取批次大小
        self.label_onehot = np.zeros_like(self.prob)  # 初始化标签的one-hot表示
        self.label_onehot[np.arange(self.batch_size), label] = 1.0  # 设置正确的标签为1
        loss = -np.sum(np.log(self.prob) * self.label_onehot) / self.batch_size  # 计算交叉熵损失
        return loss

    # Softmax损失层的反向传播计算方法，计算梯度
    def backward(self):
        bottom_diff = (self.prob - self.label_onehot) / self.batch_size  # 计算梯度
        return bottom_diff