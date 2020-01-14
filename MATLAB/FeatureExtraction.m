function [noisy_data, clean_data] = FeatureExtraction(InputPar)

%You must make your own file list and calculate each one by one
fbtype   ='htkmel';

%% Noisy and Clean waveform dir
noisy_dir = sprintf('%s/Data/train/multicondition',pwd);
clean_dir = sprintf('%s/Data/train/clean',pwd);

noisy_files=dir(noisy_dir);
noisy_files = noisy_files(~ismember({noisy_files.name},{'.','..'}));

clean_files=dir(clean_dir);
clean_files = clean_files(~ismember({clean_files.name},{'.','..'}));

filenum     =length(clean_files);
for i=1:filenum
    
    %% read binary files
    fw = fopen(fullfile(clean_dir,clean_files(i).name),'r','b');
    y  = fread(fw,'int16');
    fclose(fw);
    
    fw = fopen(fullfile(noisy_dir,noisy_files(i).name),'r','b');
    x  = fread(fw,'int16');
    fclose(fw);
    
    %% uncomment to read .wav files
    %     cleanfile = fullfile(clean_dir, clean_files(i).name);
    %     y = audioread(cleanfile); %CleanWavFile{i} is the wav file.
    %
    %     noisyfile=fullfile(noisy_dir, noisy_files(i).name);
    %     x = audioread(noisyfile);
    %%
    
	% For Speech Features
    [Log_clean_spec{i}, yphase] = Mel_Spectrum_FromX(y*1000,2,InputPar); 
    [Log_noisy_spec{i}, yphase] = Mel_Spectrum_FromX(x*1000,2,InputPar); 

    i
end

noisy_data = horzcat(Log_noisy_spec{:});
clean_data = horzcat(Log_clean_spec{:});

%noisy_data = noisy_data';
%clean_data = clean_data';
return