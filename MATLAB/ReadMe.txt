- Download the codes and save it to the local dir

For ELM
	Open ELM_All.m
		- Go to FeatureExtraction and change the directory to extract features for your data. 
	
		(a) change the directory to where you saved the files 
		(b) Change the NumberofHiddenNeurons, ActivationFunction, and regularization parameter 'C'.
			More iformation can be found in 'elm_train' File
		
			% NumberofHiddenNeurons: Number of hidden neurons for the ELM hidden layer e.g. 100, 200, 500, or 1000 etc.
			% ActivationFunction: activation function e.g. sigmoid 'sig', tangent hyperbolic 'tanh', softmax 'softmax' etc.
			% regularization parameter.
		(c) Run ELM_All
	
For HELM
	Open HELM_Main.m
		- Go to FeatureExtraction and change the directory to extract features for your data. 
		
		(a) Run HELM_Main.m
		(b) Change the N1,N2 and N3 and regularization parameter 'C' 
			% N1,N2 and N3: Number of hidden neurons for the H-ELM hidden layer e.g. 100, 200, 500. 1000 etc.
			% regularization parameter 'C': regularization parameter.	    
			More iformation can be found in the paper "Extreme Learning Machine for Multilayer Perceptron"
		(c) Go to "helm_train" for multi-layer training.  
	

If you use the following codes for your research, kindly cite and consult to "Experimental Study on Extreme Learning Machine Applications for Speech Enhancement" paper for more information.

#'''''''''''''''''''''''''''''''''''#
Author:  Tassadaq Hussain
Email: tassadaq.hussain@gmail.com
