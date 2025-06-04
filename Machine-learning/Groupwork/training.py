# training.py

from sklearn.model_selection import train_test_split
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score
import joblib

def train_and_save_model_cnn(images, labels, model_save_path):
    # 划分训练集和测试集
    X_train, X_test, y_train, y_test = train_test_split(images, labels, test_size=0.2, random_state=42)
    
    # 定义 SVM 模型
    svm_model = SVC(kernel='linear', C=1, gamma='auto')
    
    # 训练模型
    svm_model.fit(X_train, y_train)
    
    # 预测
    y_pred = svm_model.predict(X_test)
    
    # 计算准确率
    accuracy = accuracy_score(y_test, y_pred)
    print(f"训练准确率：{accuracy}")
    
    # 保存模型
    joblib.dump(svm_model, model_save_path)
    print(f"模型已保存到 {model_save_path}")

def load_model_cnn(model_path):
    model = joblib.load(model_path)
    return model
