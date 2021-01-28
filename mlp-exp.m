#!/usr/bin/octave -qf

addpath("../Docencia/apr/svn/Practicas/abp/src/mlp/nnet/");

if (nargin!=5)
printf("Usage: mlp.m <trdata> <trlabels> <nHidden> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
nHidden= str2num(arg_list{3});
trper=str2num(arg_list{4});
dvper=str2num(arg_list{5});

load(trdata);
load(trlabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);
Y= Xdv; yl = xldv;
show = 10; epochs = 300;

for i=1:length(nHidden)
[errY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden(i),epochs,show,seed)
%printf("%.1e %3d %6.3f\n",alphas(i), Ks(j), edv);
endfor

pause(10);


