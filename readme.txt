The software is the implementation of "Fast Multiple Output Regression Based on Piecewise Linear Approximation(PLA-MOR)". 

Author: Zhihui Li (lizhihui@hrbeu.edu.cn,187263204@qq.com)

The main programs and functions of PLA-MOR package show as follows. Other programs are the sub-fuctions called by the main programs.

aresbuildLineSeg.m	MOR model building by the proposed method.
arespredictLineSeg.m	Output predicting according to MOR model built by "aresbuildLineSeg.m".
cmpLineKnot.m	        Piecewise linear approximation.
cmpRRMSE.m	        RRMSE and aRRMSE calculation.
demo.m	                Demo of regression program.
inverseZeroNorm.m	Anti-normalization of the normalized vector.
showRrmse.m	        Reproducing of the predicting results made by ¡°testRrmse.m¡±.
testRrmse.m	        Training program in cross validation way.
zeroMeanNorm.m	        Normalization of vector.

There are two directories in the package.

mat         This directory contains the datasets in the paper.
testResult  This directory contains the training model files. 


