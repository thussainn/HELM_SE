function [OutputWeight,InputWeight,BiasofHiddenNeurons, T,P] = elm_train(NoisyMFC, CleanMFC, NumberofHiddenNeurons, ActivationFunction, C)

% Usage: elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
% OR:    [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%
% Input:
% TrainingData_File     - Filename of training data set
% TestingData_File      - Filename of testing data set
% Elm_Type              - 0 for regression; 1 for (both binary and multi-classes) classification
% NumberofHiddenNeurons - Number of hidden neurons assigned to the ELM
% ActivationFunction    - Type of activation function:
%                           'sig' for Sigmoidal function
%                           'sin' for Sine function
%                           'hardlim' for Hardlim function
%                           'tribas' for Triangular basis function
%                           'radbas' for Radial basis function (for additive type of SLFNs instead of RBF type of SLFNs)
%
% Output:
% TrainingTime          - Time (seconds) spent on training ELM
% TestingTime           - Time (seconds) spent on predicting ALL testing data
% TrainingAccuracy      - Training accuracy:
%                           RMSE for regression or correct classification rate for classification
% TestingAccuracy       - Testing accuracy:
%                           RMSE for regression or correct classification rate for classification
%
% MULTI-CLASSE CLASSIFICATION: NUMBER OF OUTPUT NEURONS WILL BE AUTOMATICALLY SET EQUAL TO NUMBER OF CLASSES
% FOR EXAMPLE, if there are 7 classes in all, there will have 7 output
% neurons; neuron 5 has the highest output means input belongs to 5-th class
%
% Sample1 regression: [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = elm('sinc_train', 'sinc_test', 0, 20, 'sig')
% Sample2 classification: elm('diabetes_train', 'diabetes_test', 1, 20, 'sig')
%
%%%%    Authors:    MR QIN-YU ZHU AND DR GUANG-BIN HUANG
%%%%    NANYANG TECHNOLOGICAL UNIVERSITY, SINGAPORE
%%%%    EMAIL:      EGBHUANG@NTU.EDU.SG; GBHUANG@IEEE.ORG
%%%%    WEBSITE:    http://www.ntu.edu.sg/eee/icis/cv/egbhuang.htm
%%%%    DATE:       APRIL 2004

%%%%%%%%%%% Macro definition
REGRESSION=1;
CLASSIFIER=0;

%%%%%%%%%%% Load training dataset
% NoisyMFC=load(TrainingNoisyData_File);
% CleanMFC=load(TrainingCleanData_File);
%
% T=NoisyMFC.indata;
% P=CleanMFC.outdata;                              %   Release raw training data array

T = NoisyMFC;
P = CleanMFC;
NumberofTrainingData=size(P,2);
NumberofInputNeurons=size(P,1);
%NumberofInput=size(P,1);

%%%%%%%%%%% Random generate input weights InputWeight (w_i) and biases BiasofHiddenNeurons (b_i) of hidden neurons
InputWeight=rand(NumberofHiddenNeurons,NumberofInputNeurons)*2-1;
BiasofHiddenNeurons=rand(NumberofHiddenNeurons,1);
%BiasofHiddenNeurons=rand(NumberofInput,1);
tempH=InputWeight*P;
%tempH=P;
temTH=T;
%clear P;                                            %   Release input of training data
ind=ones(1,NumberofTrainingData);
BiasMatrix=BiasofHiddenNeurons(:,ind);              %   Extend the bias matrix BiasofHiddenNeurons to match the demention of H
tempH=tempH+BiasMatrix;
temTH=temTH;

%%%%%%%%%%% Calculate hidden neuron output matrix H
switch lower(ActivationFunction)
    case {'sig','sigmoid'}
        %%%%%%%% Sigmoid
        H = 1 ./ (1 + exp(-tempH));
        TH = 1 ./ (1 + exp(-temTH));
    case {'sin','sine'}
        %%%%%%%% Sine
        H = sin(tempH);
        TH = sin(temTH);
    case {'hardlim'}
        %%%%%%%% Hard Limit
        H = double(hardlim(tempH));
        TH = double(hardlim(temTH));
    case {'tribas'}
        %%%%%%%% Triangular basis function
        H = tribas(tempH);
        TH = tribas(temTH);
    case {'radbas'}
        %%%%%%%% Radial basis function
        H = radbas(tempH);
        TH = radbas(temTH);
    case {'tan','tanh'}
        %%%%%%%% Sine
        H = tanh(tempH);
        TH = tanh(temTH);
    case {'softmax'}
        %%%%%%%% Sine
        H = softmax(tempH);
        TH = softmax(temTH);
        %%%%%%%% More activation functions can be added here
end
%clear tempH temTH;                                        %   Release the temparary array for calculation of hidden neuron output matrix H

% OutputWeight=pinv(H')*TH';                        % implementation without regularization factor //refer to 2006 Neurocomputing paper
%OutputWeight=inv(eye(size(H,1))/C+H * H') * H * T';   % faster method 1 //refer to 2012 IEEE TSMC-B paper
%implementation; one can set regularizaiton factor C properly in classification applications
OutputWeight=(eye(size(H,1))/C+H * H') \ H * T;      % faster method 2 //refer to 2012 IEEE TSMC-B paper
%implementation; one can set regularizaiton factor C properly in classification applications

% end_time_train=cputime;
%   Calculate CPU time (seconds) spent for training ELM

%%%%%%%%%%% Calculate the training accurac
OutputWeight=OutputWeight';
Y=(OutputWeight*H);                             %   Y: the actual output of the training data
TrainingAccuracy = sqrt(mse(T - Y'))               %   Calculate training accuracy (RMSE) for regression case
disp(['Training Accuracy is : ', num2str(TrainingAccuracy)]);

clear H;
end
