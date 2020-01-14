function [Log_MFCSpectrum,yphase]=Mel_Spectrum_FromX(x,AmFlag,InputPar)
% function [powspectrum,yphase]=Mel_Spectrum_FromX(x,AmFlag,FrameSize,FrameRate,FFT_SIZE,sr,minfreq,nfilts );

%function Log_MFCSpectrum=Mel_Spectrum_FromFile(fname,AmFlag);
%fname: input file name
%AmFlag=2, Power Spectrum, else Amplitude
%
FrameSize = InputPar.FrameSize;
FrameRate = InputPar.FrameRate;
FFT_SIZE = InputPar.FFT_SIZE;
sr = InputPar.SampleRate;        
minfreq = InputPar.MinFreq;

fbtype   ='htkmel';

%% For Mel Spec Features
if strcmp(InputPar.FeaType,'Mel')
    FeaDim=InputPar.FeaDim;
    nfilts=FeaDim;
    [powspectrum,x_seg,yphase]  =Spectrum(x,FrameSize,FrameRate,FFT_SIZE, AmFlag);
    maxfreq =sr/2; %half of sr
    MelCoef = MakeMelCoef(sr, nfilts, fbtype, minfreq, maxfreq, 1,FFT_SIZE);
    MFCSpectrum=Get_Mel_Spectrum(powspectrum,MelCoef);
    Log_MFCSpectrum=log10(eps+MFCSpectrum);

elseif strcmp(InputPar.FeaType,'powspec')
    %% For Power Spec Features
    [powspectrum,x_seg,yphase]  =Spectrum(x,FrameSize,FrameRate,FFT_SIZE, AmFlag); %For power spectrum extraction
%     Log_MFCSpectrum=log10(eps+powspectrum);
    Log_MFCSpectrum = powspectrum;
else
    print('Wrong Feature Type')
    return
end
return;
