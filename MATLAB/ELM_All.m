
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

%% Training
[OutputWeight,InputWeight,BiasofHiddenNeurons] = elm_train(norm_noisy_data, norm_clean_data, 1000, 'sig', 200);

%% Testing

test_noisy_path=sprintf('%s/Data/test/test_noisy',pwd);
elm_test(test_noisy_path, OutputWeight, InputWeight, BiasofHiddenNeurons, 'sig', InputPar, Info);
