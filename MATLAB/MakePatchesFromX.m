function [patches,MFCData] =MakePatchesFromX(MFCData,ws)
%Making spectrum patches from a MFC file with a window size ws
%This function is the same as
%MakePatchesWithShitfFromMFCFile(MFCFile,ws,0);
%patches is each column as one sample
%Xugang Lu @NICT
%March 9, 2012

%MFCData    =ReadMFCCData(MFCFile);
[Dim1,Dim2]=size(MFCData);
FeaDim     =Dim1;
patches    =randn(Dim2,FeaDim*(ws*2+1));
for j=1:Dim2
    if j<= ws
        Patch =MFCData(:,1:ws*2+1);
    else if j>=Dim2-ws
            Patch =MFCData(:,Dim2-ws*2:Dim2);
        else
            Patch =MFCData(:,j-ws:j+ws);
        end
    end
    patches(j,:) =reshape(Patch,FeaDim*(ws*2+1),1);
end    
patches   =patches'; %each column is a sample
return
           