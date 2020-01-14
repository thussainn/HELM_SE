function [beta, beta1, beta2, l3] = helm_train(train_x, train_y, b1, b2, b3, s, C) %% 3-Layer H-ELM
tic
%% Unsupervised learning
%% First layer 
A1 = train_x * b1; 
beta1  =  sparse_elm_autoencoder(A1,train_x,1e-3,1000)';
T1 = train_x * beta1;
fprintf(1,'Layer 1: Max Val of Output %f Min Val %f\n',max(T1(:)),min(T1(:)));

%% Second layer 
H2 = T1;
A2 = H2 * b2;
beta2 = sparse_elm_autoencoder(A2,H2,1e-3,1000)';

T2 = H2 * beta2;
fprintf(1,'Layer 2: Max Val of Output %f Min Val %f\n',max(T2(:)),min(T2(:)));

%% Supervised learning 
H3 = [T2 .1 * ones(size(T2,1),1)]; 
T3 = H3 * b3; 
l3 = max(max(T3)); 
l3 = s/l3;
T3 = T3 * l3;

% % T3 = tansig(T3);
T3 = 1 ./ (1 + exp(-T3));  % sigmoid

%% Finish Training
if C == 0
    disp('No regularization');
    beta=pinv(T3) * train_y'; %beta with no penalty term
else
    beta = (T3'  *  T3+eye(size(T3',1)) * (C)) \ ( T3'  *  train_y'); %beta, output matrix, calculated using a penalty term.
end
%% Calculate the training accuracy

%%%%%%%%%%% Calculate the training accuracy
Y = T3 * beta; %   Y: the actual output of the training data
%  Y=Y';
toc;
TrainingAccuracy = sqrt(mse(Y-train_y'));               %   Calculate training accuracy (RMSE) for regression case
disp(['Training Accuracy is : ', num2str(TrainingAccuracy)]);
end