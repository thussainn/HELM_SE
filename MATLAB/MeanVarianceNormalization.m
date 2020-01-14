function [NormedData,td_mean, td_var] = MeanVarianceNormalization(TrainData,CNormFlag)
%function NormedData = MeanVarianceNormalization(TrainData,CNormFlag)
%TrainData, each column is a data sample
%CNormFlag =0; no normalization
%CNormFlag=1; mean normalization
%CNormFlag=2; mean and variance normalization
%Xugang Lu @NICT
%July 17, 2012

epsilon =1.0; %1
switch CNormFlag
    case 0
        disp('no normalization');
    case 1
        td_mean=mean(TrainData,2);
        TrainData = bsxfun(@minus, TrainData, mean(TrainData,2));
    case 2
        td_mean=mean(TrainData,2);
        td_var=sqrt(var(TrainData,[],2)+epsilon);
        TrainData = bsxfun(@rdivide, bsxfun(@minus, TrainData, mean(TrainData,2)), sqrt(var(TrainData,[],2)+epsilon));
    otherwise
        disp('wrong normalization type');
        return;
end     

NormedData=TrainData;

return