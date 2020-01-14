function elm_test(test_noisy_path, OutputWeight, InputWeight, BiasofHiddenNeurons, ActivationFunction, InputPar, Info)

CNormFlag       =2;
sr = InputPar.SampleRate;
minfreq = InputPar.MinFreq;
maxfreq           =sr/2;

nfft              =512;
sumpower          =1;
bwidth            =1;

noisy_dir = dir(test_noisy_path);
noisy_dir = noisy_dir(~ismember({noisy_dir.name},{'.','..'}));
filenum     =length(noisy_dir);

for i=1:filenum
    %[x fs]=audioread(fullfile(test_noisy_path,noisy_dir(i).name));
    %length_origin=length(x);
    %i
    fw = fopen(fullfile(test_noisy_path,noisy_dir(i).name),'r','b');
    x=fread(fw,'int16');     fclose(fw);
    length_origin=length(x);
    
    [Log_Spectrum, yphase] = Mel_Spectrum_FromX(x, 2, InputPar);
    Log_Spectrum = Log_Spectrum + (Log_Spectrum == 0)*eps;
    FeaDim = size(Log_Spectrum,1);
    
    [patches, MFCData]        =MakePatchesFromX(Log_Spectrum, InputPar.Ws);
    [Data_MVN, Mean_noisy, Var_noisy] =MeanVarianceNormalization(patches, CNormFlag);
    
    OrigSpectrum             =Data_MVN ;
    tempH_test = InputWeight * OrigSpectrum;
    ind = ones(1,size(OrigSpectrum, 2));
    BiasMatrix = BiasofHiddenNeurons(:,ind);
    tempH_test = tempH_test + BiasMatrix;
    
    %%%%%%%%%%% Calculate hidden neuron output matrix H
    switch lower(ActivationFunction)
        case {'sig','sigmoid'}
            %%%%%%%% Sigmoid
            H_test = 1 ./ (1 + exp(-tempH_test));
        case {'sin','sine'}
            %%%%%%%% Sine
            H_test = sin(tempH_test);
        case {'hardlim'}
            %%%%%%%% Hard Limit
            H_test = double(hardlim(tempH_test));
        case {'tribas'}
            %%%%%%%% Triangular basis function
            H_test = tribas(tempH_test);
        case {'radbas'}
            %%%%%%%% Radial basis function
            H_test = radbas(tempH_test);
        case {'tan','tanh'}
            %%%%%%%% Sine
            H_test = tanh(tempH_test);
        case {'softmax'}
            %%%%%%%% Sine
            H_test = softmax(tempH_test);
            
            %%%%%%%% More activation functions can be added here
    end
    
    ReconSpectrumPatch       =(H_test' * OutputWeight')';
    ReconSpectrumPatch       =De_MeanVarianceNormalization(ReconSpectrumPatch, CNormFlag, Info.mean_clean, Info.var_clean);
    ReconSpectrum            =SpectrumRecoverFromPatch(ReconSpectrumPatch, FeaDim);
    %% For Mel-Spectral
    if strcmp(InputPar.FeaType,'Mel')
        MelSpec             =power(10, ReconSpectrum);
        [spec,wts,iwts]     =MelSpectrum2PowerSpectrum(MelSpec, sr, nfft, 'htkmel', minfreq, maxfreq, sumpower, bwidth); % for 16KHz
        log10powerspectrum  =log10(spec);
        %     log10powerspectrum  =spec;
    else
        %% For Log Power Spectral Features
        MelSpec             =power(10,ReconSpectrum);
        log10powerspectrum  =MelSpec;
        %         log10powerspectrum  = ReconSpectrum;
    end
    fs=sr;
    sig = PowerSpectrum2Wave(log10powerspectrum,yphase,InputPar);
    siga=sig/max(abs(sig));
    %     siga=sig/1000;
    siga2=[];
    length_enhanced=length(siga);
    if (length_origin>length_enhanced)
        a=zeros((length_origin-length_enhanced),1);
        siga2=[siga' a']';
    else
        for k=1:length_origin
            siga2(k)= siga(k);
        end
    end
    
    enhanced_path=sprintf('%s/Data/enhanced/ELM',pwd);
    mkdir(enhanced_path);
    
    fileID = fopen(fullfile(enhanced_path, noisy_dir(i).name), 'w', 'b');
    fwrite(fileID, siga2*1000, 'int16');
    fclose(fileID);
    
    %     enhanced_file = fullfile(enhanced_path, noisy_dir(i).name);
    %     audiowrite(enhanced_file, siga2, fs);
end
