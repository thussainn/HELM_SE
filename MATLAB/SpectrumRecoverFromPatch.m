function Spectrum =SpectrumRecoverFromPatch(patch,FeaDim)
%Recover the spectrum from patch
%Xugang Lu @NICT
%Feb. 16, 2012

[dim1,dim2] =size(patch);
Psize       =dim1/FeaDim;
tmp1        =reshape(patch,FeaDim,Psize,dim2);

%Spectrum   =reshape(tmp1(:,fix(Psize/2),:),FeaDim,dim2);
Spectrum   =reshape(tmp1(:,ceil(Psize/2),:),FeaDim,dim2);
