#!/usr/bin/octave -qf

addpath("~/DiscoW/APR/redesNeuronales/nnet_apr");

if (nargin!=6)
printf("Usage: mlp-exp.m <trdata> <trlabels> <nHidden> <pcanHidden> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
nHidden= str2num(arg_list{3});
pcanHidden=str2num(arg_list{4});
trper=str2num(arg_list{5});
dvper=str2num(arg_list{6});

load(trdata);
load(trlabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);
M=N-Ntr;
show = 10; epochs = 300;

%parte PCA reducimos dimensionalidad
[m W]=pca(Xtr);

Xtr=Xtr-m;
Xdv=Xdv-m;
Y= Xdv; yl = xldv;

# f1=fopen("d30.out","w");

pcaXtr = Xtr *W(:,1:pcanHidden);
pcaXdv = Xdv *W(:,1:pcanHidden);
pcaY = Y * W(:,1:pcanHidden);
errY = mlp(pcaXtr,xltr,pcaXdv,xldv,pcaY,yl,nHidden,epochs,show,seed);

nerr=17; 
m=nerr/M
s=sqrt(m*(1-m)/M)
r=1.96*s
printf("I=[%.3f, %.3f]\n",m-r,m+r);

# printf("%6.3f\n",errY);


pause(10);