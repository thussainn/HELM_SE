function helm_test(test_noisy_path, beta, beta1, beta2, b3, l3, InputPar, Info)

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
    %%%% to read binary files
    fw = fopen(fullfile(test_noisy_path, noisy_dir(i).name),'r','b');
    x = fread(fw,'int16');
    x = x/std(x);
    fclose(fw);
    %% to read .wav file
    % test_file=fullfile(test_noisy_path, noisy_dir(i).name);
    % fw = audioread(test_file);
    % x = fw/std(fw);
    %%
    length_origin = length(x);
    
    [Log_Spectrum, yphase] = Mel_Spectrum_FromX(x, 2, InputPar);
    Log_Spectrum=Log_Spectrum+(Log_Spectrum == 0)*eps;
    FeaDim = size(Log_Spectrum,1);
    
    [patches, MFCData]        =MakePatchesFromX(Log_Spectrum, InputPar.Ws);
    [Data_MVN, Mean_noisy, Var_noisy] =MeanVarianceNormalization(patches, CNormFlag);
    %%
    tic;
    HH1 = Data_MVN;
    TT1 = HH1' * beta1;
    %%  Second layer feedforward
    HH2 = TT1;
    TT2 = HH2 * beta2;
    %%  Last layer feedforward
    HH3 = [TT2 .1 * ones(size(TT2,1),1)];
    
    TT3 = HH3 * b3;
    TT3 = TT3 * l3;
    TT3 = 1 ./ (1 + exp(-TT3)); %3-layer H-ELM
    %     %  TT3 = tansig(HH3 * b3 * l3);
    
    x = TT3 * beta;
    x = x';
    
    %%
    ReconSpectrumPatch       =De_MeanVarianceNormalization(x, CNormFlag, Info.mean_clean, Info.var_clean);
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
    
    fs = sr;
    sig = PowerSpectrum2Wave(log10powerspectrum,yphase,InputPar);
    siga = sig/max(abs(sig));
    
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
    
    % % write data
    enhanced_path=sprintf('%s/Data/enhanced/HELM_1',pwd);
    mkdir(enhanced_path);
    
    fileID = fopen(fullfile(enhanced_path, noisy_dir(i).name), 'w', 'b');
    fwrite(fileID, siga2*1000, 'int16');
    fclose(fileID);
    
    %     enhanced_file = fullfile(enhanced_path, noisy_dir(i).name);
    %     audiowrite(enhanced_file, siga2, fs);
    
    %     figure;
    %     subplot(2,1,1); plot(Testfile);
    %     title('Noisy File')
    %
    %     subplot(2,1,2); plot(siga2);ylim([-8000 8000]);
    %     title('Enhanced File')
    %
end
return
