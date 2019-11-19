
# Semiconductor Process Wafer Topographical Map Interpolation

by Luis Castaneda

## Abstract

In this project I propose a novel usage of deep convolutional generative adversarial networks to take sparse topographical data sets and interpolate them. I will be using techniques from established “Inpainting” DCGAN algorithms to fill in regions of missing data, as well as enhancing the results with Single Image Super Resolution (SISR) algorithms. These “images” will actually be maps where the z coordinate of the maps are treated as pixel intensity. In applying these methods, it is the goal to produce useful maps which can be used for wafer inspections, in a reduced amount of time by reducing the physical data collection and applying deep-learning based interpolation techniques.  
# Dependencies
* Python 3.6
* Keras
* Tensorflow

# How to use this repository

If you want to dig into the code, the primary implementations of the new `PConv2D` keras layer as well as the `UNet`-like architecture using these partial convolutional layers can be found in `libs/pconv_layer.py` and `libs/pconv_model.py`, respectively - this is where the bulk of the implementation can be found. Beyond this I've set up four jupyter notebooks, which details the several steps I went through while implementing the network, namely:

Step 1: Creating random irregular masks<br />
Step 2: Implementing and testing the implementation of the `PConv2D` layer<br />
Step 3: Implementing and testing the UNet architecture with `PConv2D` layers<br />
Step 4: Training & testing the final architecture on ImageNet<br />
Step 5: Simplistic attempt at predicting arbitrary image sizes through image chunking

## Pre-trained weights
I've ported the VGG16 weights from PyTorch to keras; this means the `1/255.` pixel scaling can be used for the VGG16 network similarly to PyTorch. 
* [Ported VGG 16 weights](https://drive.google.com/open?id=1HOzmKQFljTdKWftEP-kWD7p2paEaeHM0)
* [PConv on Imagenet](https://drive.google.com/open?id=1OdbuNJj4gV9KUoknQG063jJrJ1srhBvU)
* PConv on Places2 [needs training]
* PConv on CelebaHQ [needs training]

## Training on your own dataset
You can either go directly to [step 4 notebook](https://github.com/MathiasGruber/PConv-Keras/blob/master/notebooks/Step4%20-%20Imagenet%20Training.ipynb), or alternatively use the CLI (make sure to download the converted VGG16 weights):
```
python main.py \
    --name MyDataset \
    --train TRAINING_PATH \
    --validation VALIDATION_PATH \
    --test TEST_PATH \
    --vgg_path './data/logs/pytorch_to_keras_vgg16.h5'
```

## Sample result
TBD
