# 前言

随着深度学习技术在视觉领域的应用和发展，让我们看到了利用AI来自动进行垃圾分类的可能，通过摄像头拍摄垃圾图片，检测图片中垃圾的类别，从而可以让机器自动进行垃圾分拣，极大地提高垃圾分拣效率。

# 运行环境

>python3.6

>tensorflow 1.13.1

>keras 2.2.4
>
>numpy 1.15.0
>
>keras_efficientnets
>
>

新版本运行的话可能会运行不成功。

# garbage_classify


## 项目
本项目采用深圳市垃圾分类标准，任务是对垃圾图片进行分类，即首先识别出垃圾图片中物品的类别（比如易拉罐、果皮等），然后查询垃圾分类规则，输出该垃圾图片中物品属于可回收物、厨余垃圾、有害垃圾和其他垃圾中的哪一种。
模型输出格式示例：
    

    {
    
        " result ": "可回收物/易拉罐"
    
    }

## 垃圾种类40类

    {
        "0": "其他垃圾/一次性快餐盒",
        "1": "其他垃圾/污损塑料",
        "2": "其他垃圾/烟蒂",
        "3": "其他垃圾/牙签",
        "4": "其他垃圾/破碎花盆及碟碗",
        "5": "其他垃圾/竹筷",
        "6": "厨余垃圾/剩饭剩菜",
        "7": "厨余垃圾/大骨头",
        "8": "厨余垃圾/水果果皮",
        "9": "厨余垃圾/水果果肉",
        "10": "厨余垃圾/茶叶渣",
        "11": "厨余垃圾/菜叶菜根",
        "12": "厨余垃圾/蛋壳",
        "13": "厨余垃圾/鱼骨",
        "14": "可回收物/充电宝",
        "15": "可回收物/包",
        "16": "可回收物/化妆品瓶",
        "17": "可回收物/塑料玩具",
        "18": "可回收物/塑料碗盆",
        "19": "可回收物/塑料衣架",
        "20": "可回收物/快递纸袋",
        "21": "可回收物/插头电线",
        "22": "可回收物/旧衣服",
        "23": "可回收物/易拉罐",
        "24": "可回收物/枕头",
        "25": "可回收物/毛绒玩具",
        "26": "可回收物/洗发水瓶",
        "27": "可回收物/玻璃杯",
        "28": "可回收物/皮鞋",
        "29": "可回收物/砧板",
        "30": "可回收物/纸板箱",
        "31": "可回收物/调料瓶",
        "32": "可回收物/酒瓶",
        "33": "可回收物/金属食品罐",
        "34": "可回收物/锅",
        "35": "可回收物/食用油桶",
        "36": "可回收物/饮料瓶",
        "37": "有害垃圾/干电池",
        "38": "有害垃圾/软膏",
        "39": "有害垃圾/过期药物"
    }
## efficientNet默认参数

        (width_coefficient, depth_coefficient, resolution, dropout_rate)
        'efficientnet-b0': (1.0, 1.0, 224, 0.2),
        'efficientnet-b1': (1.0, 1.1, 240, 0.2),
        'efficientnet-b2': (1.1, 1.2, 260, 0.3),
        'efficientnet-b3': (1.2, 1.4, 300, 0.3),
        'efficientnet-b4': (1.4, 1.8, 380, 0.4),
        'efficientnet-b5': (1.6, 2.2, 456, 0.4),
        'efficientnet-b6': (1.8, 2.6, 528, 0.5),
        'efficientnet-b7': (2.0, 3.1, 600, 0.5),

efficientNet的论文地址：https://arxiv.org/pdf/1905.11946.pdf


## 代码解析
1.

使用[组归一化（GroupNormalization）](https://arxiv.org/abs/1803.08494)代替[批量归一化（batch_normalization）](https://arxiv.org/abs/1502.03167)-解决当Batch_size过小导致的准确率下降。当batch_size小于16时，BN的error率
逐渐上升，`train.py`。
    
    

    for i, layer in enumerate(model.layers):
        if "batch_normalization" in layer.name:
            model.layers[i] = GroupNormalization(groups=32, axis=-1, epsilon=0.00001)

2.[NAdam优化器](http://cs229.stanford.edu/proj2015/054_report.pdf)
    
    

    optimizer = Nadam(lr=FLAGS.learning_rate, beta_1=0.9, beta_2=0.999, epsilon=1e-08, schedule_decay=0.004)

3.自定义学习率-[SGDR余弦退火学习率](https://arxiv.org/abs/1608.03983)
    
    

    sample_count = len(train_sequence) * FLAGS.batch_size
    epochs = FLAGS.max_epochs
    warmup_epoch = 5
    batch_size = FLAGS.batch_size
    learning_rate_base = FLAGS.learning_rate
    total_steps = int(epochs * sample_count / batch_size)
    warmup_steps = int(warmup_epoch * sample_count / batch_size)
    
    warm_up_lr = WarmUpCosineDecayScheduler(learning_rate_base=learning_rate_base,
                                            total_steps=total_steps,
                                            warmup_learning_rate=0,
                                            warmup_steps=warmup_steps,
                                            hold_base_rate_steps=0,
                                            )

4.数据增强：随机水平翻转、随机垂直翻转、以一定概率随机旋转90°、180°、270°、随机crop(0-10%)等(详细代码请看`aug.py`和`data_gen.py`)

    def img_aug(self, img):
        data_gen = ImageDataGenerator()
        dic_parameter = {'flip_horizontal': random.choice([True, False]),
                         'flip_vertical': random.choice([True, False]),
                         'theta': random.choice([0, 0, 0, 90, 180, 270])
                        }


        img_aug = data_gen.apply_transform(img, transform_parameters=dic_parameter)
        return img_aug


    from imgaug import augmenters as iaa
    import imgaug as ia
    
    def augumentor(image):
        sometimes = lambda aug: iaa.Sometimes(0.5, aug)
        seq = iaa.Sequential(
            [
                iaa.Fliplr(0.5),
                iaa.Flipud(0.5),
                iaa.Affine(rotate=(-10, 10)),
                sometimes(iaa.Crop(percent=(0, 0.1), keep_size=True)),
            ],
            random_order=True
        )


        image_aug = seq.augment_image(image)
    
        return image_aug

5.标签平滑`data_gen.py`
    
    

    def smooth_labels(y, smooth_factor=0.1):
        assert len(y.shape) == 2
        if 0 <= smooth_factor <= 1:
            # label smoothing ref: https://www.robots.ox.ac.uk/~vgg/rg/papers/reinception.pdf
            y *= 1 - smooth_factor
            y += smooth_factor / y.shape[1]
        else:
            raise Exception(
                'Invalid label smoothing factor: ' + str(smooth_factor))
        return y

6.数据归一化：得到所有图像的位置信息`Save_path.py`并计算所有图像的均值和方差`mead_std.py`
    
    

    normMean = [0.56719673 0.5293289  0.48351972]
    normStd = [0.20874391 0.21455203 0.22451781]


​    
​    img = np.asarray(img, np.float32) / 255.0
​    mean = [0.56719673, 0.5293289, 0.48351972]
​    std = [0.20874391, 0.21455203, 0.22451781]
​    img[..., 0] -= mean[0]
​    img[..., 1] -= mean[1]
​    img[..., 2] -= mean[2]
​    img[..., 0] /= std[0]
​    img[..., 1] /= std[1]
​    img[..., 2] /= std[2]

## 各部分代码解析

* `deploy_scripts`——推理文件
      
  
      1.self.input_size = 456 
  
  
  ​    
  ​    2. def _inference(self, data):
  ​    """
  ​    model inference function
  ​    Here are a inference example of resnet, if you use another model, please modify this function
  ​    """
  ​    img = data[self.input_key_1]
  ​    img = img[np.newaxis, :, :, :]  # the input tensor shape of resnet is [?, 224, 224, 3]
  ​    img = np.asarray(img, np.float32) / 255.0
  ​    mean = [0.56719673, 0.5293289, 0.48351972]
  ​    std = [0.20874391, 0.21455203, 0.22451781]
  ​    img[..., 0] -= mean[0]
  ​    img[..., 1] -= mean[1]
  ​    img[..., 2] -= mean[2]
  ​    img[..., 0] /= std[0]
  ​    img[..., 1] /= std[1]
  ​    img[..., 2] /= std[2]
  ​    pred_score = self.sess.run([self.output_score], feed_dict={self.input_images: img})
  ​    if pred_score is not None:
  ​        pred_label = np.argmax(pred_score[0], axis=1)[0]
  ​        result = {'result': self.label_id_name_dict[str(pred_label)]}
  ​    else:
  ​        result = {'result': 'predict score is None'}
  ​    return result


* `aug.py`——图像增强代码(`imgaug`函数）

* `data_gen.py`——数据预处理代码，包括数据增强、标签平滑以及train和val的划分

* `eval.py`——估值函数

* `Groupnormalization.py`——组归一化

* `mean_std.py`——图像均值和方差

* `Network.py`——ResNet50, SE-ResNet50, Xeception, SE-Xeception, efficientNetB5

* `run.py`——运行代码

* `save_model.py`——保存模型

* `Save_path.py`——图像位置信息

* `train.py`——训练网络部分，包括网络，loss, optimizer等

* `warmup_cosine_decay_scheduler.py`——余弦退火学习率

* `pip-requirements.txt`——安装其他所需的库, 安装命令为：`pip install -r requirements.txt`

## 使用

### 运行
* 运行`Save_path.py`得到图像的位置信息
* 运行`mean_std.py`得到图像的均值和方差
* `run.py`——训练
  
* 建议以上操作需要放在一个目录下
  
  
      python run.py --data_url='./garbage_classify/train_data' --train_url='./model_snapshots' --deploy_script_path='./deploy_scripts'
  
* `run.py`——保存为pd
      
      
      
  
        python run.py --mode=save_pb --deploy_script_path='./deploy_scripts' --freeze_weights_file_path='./model_snapshots/weights_024_0.9470.h5' --num_classes=40



* `run.py`——估值
  
    
  
      python run.py --mode=eval --eval_pb_path='./model_snapshots/model' --test_data_url='./garbage_classify/train_data'
  
## 增添SVM分类器


> 当模型训练完之后，用训练好的模型预测训练数据，并将它们保存在数组中。然后放到SVC中进行训练，最后将训练好的分类器对抽取的测试数据特征进行分类。


代码如下：

    target_pre_con = []
    target_con = []
    for i, data in tqdm(enumerate(trian_dataloaders_dict['all_data'])):
    
        input, target = data
        input, target = input.to(device), target.to(device)
        target_pre = model(input)
    
        target_pre = target_pre.cpu()
        target = target.cpu()
    
        target_pre = target_pre.detach().numpy()
        target = target.detach().numpy()
    
        target_pre_con.extend(target_pre)
        target_con.extend(target)
    
    target_pre_con = np.asarray(target_pre_con)
    target_con = np.asarray(target_con)
    
    print(target_pre_con.shape)
    print(target_con.shape)
    # 提取特征用clf：svm
    clf = SVC(kernel='rbf', gamma='auto')
    clf.fit(target_pre_con, target_con)
    
    for i, (input, filepath) in tqdm(enumerate(test_loader)):
        # print(input.shape[1])
        with torch.no_grad():
            image_var = input.to(device)
            y_pred = model(image_var)
            label = y_pred.cpu().data.numpy()
            # 提取特征用clf分类
            label = clf.predict(label)
            labels.append(label)

 



## 决策树分类器和随机森林分类器

只需要将clf换成`DecisionTreeClassifier()`或`RandomForestClassifier()`即可。

```
from sklearn.tree import DecisionTreeClassifier
   
from sklearn.ensemble import RandomForestClassifier
   
clf = DecisionTreeClassifier()
   
clf = RandomForestClassifier()
```



## 实验结果

* 标签平滑和数据归一化处理、学习率策略的调整`ReduceLROnPlateau`换成`WarmUpCosineDecayScheduler`，最终准确率在85%左右




# 后续

1. 这个模型并不能处理多个物品出现在一张图片上的问题，这需要后期引入SAM模型，进行更深层次的图像分割，将每一个物体作为掩码分别输入，然后进行处理。这需要进一步的调整架构，是一个另外的领域。

   













