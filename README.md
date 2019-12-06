
# Semiconductor Process Wafer Topographical Map Interpolation

by Luis Castaneda

## Abstract

In this project I propose a novel usage of deep convolutional generative adversarial networks to take sparse topographical data sets and interpolate them. I will be using techniques from established “Inpainting” DCGAN algorithms to fill in regions of missing data, as well as enhancing the results with Single Image Super Resolution (SISR) algorithms. These “images” will actually be maps where the z coordinate of the maps are treated as pixel intensity. In applying these methods, it is the goal to produce useful maps which can be used for wafer inspections, in a reduced amount of time by reducing the physical data collection and applying deep-learning based interpolation techniques.  

# Dependencies
* Python 3.6
* Keras 2.2.4
* Tensorflow 1.12

# How to use this repository

Please download and unzip the 
    Step 0: WaferPreprocess.zip 
    Step 1: WaferIntaint-PConv-Keras
    Setp 2: WaferUpscale-dcscn-super-resolution

# ==============================

## Step 0: Use Matlab to Pre-process Wafer Map FMI Files

# ==============================

## Step 1: WaferIntaint-PConv

![UNet with Partial Convolutions](https://github.com/luismicas/CS230Project/blob/master/images/UNet.png)

## Pre-trained weights
* [Ported VGG 16 weights](https://drive.google.com/open?id=1HOzmKQFljTdKWftEP-kWD7p2paEaeHM0)
* Please email luismicas@standford.edu for weight specificly trainned on customer wafer data sets.

## Training on your own dataset
```
python main.py \
    --name MyDataset \
    --train TRAINING_PATH \
    --validation VALIDATION_PATH \
    --test TEST_PATH \
    --vgg_path './data/logs/pytorch_to_keras_vgg16.h5'
```

## Sample result

![Residual Error](https://github.com/luismicas/CS230Project/blob/master/images/ResidualsPlot.png)

# ==============================
## Step 2: WaferUpscale

![CNN with Bicubic Skip Connection](https://github.com/luismicas/CS230Project/blob/master/images/CNN.png)

## Pre-trained weights
* [Ported VGG 16 weights](https://drive.google.com/open?id=1HOzmKQFljTdKWftEP-kWD7p2paEaeHM0)
* Please email luismicas@standford.edu for weight specificly trainned on customer wafer data sets.

## Training on your own dataset
```
# apply super resolution with small model
python sr.py --file=your_file.png --layers=8 --filters=96
```

## Sample result
![Results](https://github.com/luismicas/CS230Project/blob/master/images/Results.png)
