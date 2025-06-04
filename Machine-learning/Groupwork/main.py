# main_program.py

from data_preprocessing import prepare_dataset_cnn
from training import train_and_save_model_cnn, load_model_cnn
from testing import predict_image_class_cnn

if __name__ == "__main__":
    # 定义数据集路径和模型保存路径
    dataset_dir = 'autodl-tmp/garbage_classify_v2/train_data_v2'
    model_save_path = 'garbage_classify/model_save.txt'
    
    # 数据预处理
    images, labels = prepare_dataset_cnn(dataset_dir)
    
    # 训练模型
    train_and_save_model_cnn(images, labels, model_save_path)
    
    # 加载模型
    loaded_model = load_model_cnn(model_save_path)
    
    # 测试预测
    test_image_path = "autodl-tmp/garbage_classify_v2/train_data_v2/img_1.jpg"
    predicted_class = predict_image_class_cnn(test_image_path, loaded_model)
    print(f"预测的垃圾类别为：{predicted_class}")
