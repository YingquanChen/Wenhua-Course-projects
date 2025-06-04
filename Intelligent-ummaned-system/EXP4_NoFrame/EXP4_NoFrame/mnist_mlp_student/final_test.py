import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
from stu_upload.layers_1 import FullyConnectedLayer, ReLULayer, SoftmaxLossLayer
from stu_upload.mnist_mlp_cpu import MNIST_MLP

# 假设我们已经有一个训练好的模型参数文件
TRAINED_MODEL_PARAMS = r"E:\Grade3\智能\EXP4_NoFrame\EXP4_NoFrame\mnist_mlp_student\mlp-32-16-10epoch.npy"

# 创建MNIST_MLP实例
mlp = MNIST_MLP(batch_size=100, input_size=784, hidden1=32, hidden2=16, out_classes=10, lr=0.01, max_epoch=1, print_iter=100)

# 构建模型结构
mlp.build_model()

# 初始化模型参数
mlp.init_model()

# 加载训练好的模型参数
mlp.load_model(TRAINED_MODEL_PARAMS)

# 编写图像推理函数
def infer_image(mlp, image_path):
    """
    对单个图像进行推理。

    参数:
    mlp -- 训练好的MNIST_MLP模型实例。
    image_path -- 图像文件的路径。

    返回:
    predicted_class -- 预测的类别。
    """
    # 读取图像文件
    image = Image.open(image_path).convert('L')  # 转换为灰度图

    # 将图像大小调整为28x28像素
    image = image.resize((28, 28), Image.ANTIALIAS)

    # 将图像数据转换为numpy数组，并归一化到0-1范围内
    image = np.array(image).astype(np.float32) / 255.0

    # 将图像数组展平为一维数组
    image = image.flatten()

    # 执行前向传播，获取预测概率
    prob = mlp.forward(image.reshape(1, -1))

    # 获取最大概率的索引，作为预测的类别
    predicted_class = np.argmax(prob, axis=1)

    return predicted_class

# 假设我们有一个MNIST图像
example_image = r"E:\Grade3\智能\number5.jpg"  # 这里应该替换为一个真实的MNIST图像

# 对图像进行推理
predicted_class = infer_image(mlp, example_image)

print(f"The predicted class for the input image is: {predicted_class[0]}")