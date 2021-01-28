#!/usr/bin/octave -qf

if (nargin!=7)
printf("Usage: mixgaussian-exp.m <trdata> <trlabels> <pcaKs> <Ks> <alphas> <%%trper> <%%dvper>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
pcaKs= str2num(arg_list{3});
Ks= str2num(arg_list{4});
alphas=str2num(arg_list{5});
trper=str2num(arg_list{6});
dvper=str2num(arg_list{7});

load(trdata);
load(trlabs);

N=rows(X);
seed=23; rand("seed",seed); permutation=randperm(N);
X=X(permutation,:); xl=xl(permutation,:);

Ntr=round(trper/100*N);
Ndv=round(dvper/100*N);
Xtr=X(1:Ntr,:); xltr=xl(1:Ntr);
Xdv=X(N-Ndv+1:N,:); xldv=xl(N-Ndv+1:N);

%parte PCA reducimos dimensionalidad
[m W]=pca(Xtr);

Xtr=Xtr-m;
Xdv=Xdv-m;

%vamos a escribir el resultado en un fichero para luego hacer la grafica
f1=fopen("eva.out","w");

printf("\n  alpha pca  Ks  dv-err");
printf("\n------- ---- --- -----\n");


pcaXtr = Xtr *W(:,1:pcaKs);
pcaXdv = Xdv *W(:,1:pcaKs);
edv = mixgaussian(pcaXtr,xltr,pcaXdv,xldv,Ks,alphas);		
fprintf(f1,"%.1e %3d %6.3f\n",alphas, pcaKs, Ks, edv);
printf("alpha: %.1e pcaKs: Ks: %3d edv: %6.3f\n",alphas, pcaKs, Ks, edv);
fclose(f1);