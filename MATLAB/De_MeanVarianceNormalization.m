function TrainData_Norm = De_MeanVarianceNormalization(TrainData,CNormFlag,MyMean,MyVar)
%function NormedData = MeanVarianceNormalization(TrainData,CNormFlag)
%TrainData, each column is a data sample
%CNormFlag =0; no normalization
%CNormFlag=1; mean normalization
%CNormFlag=2; mean and variance normalization
%Xugang Lu @NICT
%July 17, 2012

%epsilon =1; %1
switch CNormFlag
    case 0
        disp('no normalization');
        TrainData_Norm = TrainData;
    case 1
        TrainData_Norm = bsxfun(@plus, TrainData, MyMean);
    case 2
        TrainData_Norm_M  = bsxfun(@times, TrainData, MyVar);
        TrainData_Norm =bsxfun(@plus,TrainData_Norm_M, MyMean);        
        %TrainData_Norm=bsxfun(@plus, bsxfun(@times, TrainData, MyVar), MyMean);
    otherwise
        disp('wrong normalization type');
        return;
end     


return