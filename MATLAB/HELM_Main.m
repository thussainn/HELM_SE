% clear all
rand('state',0)

%% Parameter Setting
%%%% For GLOBAL SETTING
InputPar.SampleRate  =16000;        
InputPar.FFT_SIZE    =512;
%%%% For GLOBAL SETTING

%%%% For STFT
InputPar.FrameSize   =512; %32ms per frame
InputPar.FrameRate   =256; %16ms frame shift
InputPar.FeaDim      =InputPar.FrameSize/2+1;
%%%% For STFT

%%%% For MelSpec
InputPar.MinFreq   =60;
InputPar.MelFiltNum=80;
InputPar.SumPower  =1;
InputPar.BWidth    =1;
InputPar.FeaDim    =80;
%%%% For MelSpec

InputPar.Ws          =2;
InputPar.FeaType     = 'Mel'; %'powspec' or 'Mel' 

%% Feature Extraction and Mean Variance Normalization
[noisy_data, clean_data] = FeatureExtraction(InputPar);
noisy_data = MakePatchesFromX(noisy_data, InputPar.Ws);  %% for contextual window
clean_data = MakePatchesFromX(clean_data, InputPar.Ws);  

[norm_noisy_data, noisy_mean, noisy_var] = MeanVarianceNormalization(noisy_data, 2);
[norm_clean_data, clean_mean, clean_var] = MeanVarianceNormalization(clean_data, 2);
norm_noisy_data = norm_noisy_data';

Info.mean_clean = clean_mean;
Info.var_clean = clean_var;
%%   Define Layer Size
N1 = 100; % First hidden linear layer dimension
N2 = 100; % Second hidden linear layer dimension
N3 = 500; % Last layer for standard ELM

% rand('state',16917921)   % 5000
% rand('state',67797325)   % 12000

b1 = 2*rand(size(norm_noisy_data,2),N1+1)-1;
b2 = 2*rand(N1+1,N2)-1;
b3 = orth(2*rand(N2+1,N3)'-1)';

 C = 200; 
 s = 39.8; % C is the L2 penalty of the last layer ELM and s is the scaling factor.

%% Train Stage
[beta, beta1, beta2,l3] = helm_train(norm_noisy_data, norm_clean_data, b1, b2, b3, s, C);

%% Test Stage
test_noisy_path = sprintf('%s/Data/test/test_noisy',pwd);
helm_test(test_noisy_path, beta, beta1, beta2, b3, l3, InputPar, Info);
