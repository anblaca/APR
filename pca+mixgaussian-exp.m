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
f1=fopen("result3.out","w");

printf("\n  alpha pca  Ks  dv-err");
printf("\n------- ---- --- -----\n");


for i=1:length(alphas)
	for k=1:length(pcaKs)
		pcaXtr = Xtr *W(:,1:pcaKs(k));
  		pcaXdv = Xdv *W(:,1:pcaKs(k));
		for j = 1:length(Ks)
			edv = mixgaussian(pcaXtr,xltr,pcaXdv,xldv,Ks(j),alphas(i));		
			fprintf(f1,"%.1e %3d %6.3f\n",alphas(i), pcaKs(k), Ks(j), edv);
			printf("alpha: %.1e pcaKs: Ks: %3d edv: %6.3f\n",alphas(i), pcaKs(k), Ks(j), edv);
		end
	end
	
end
fclose(f1);

%./pca+mixgaussian-exp.m mnist/train-images-idx3-ubyte.mat.gz mnist/train-labels-idx1-ubyte.mat.gz "[1,2,5,10,20,50,100]" "[1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 2e-1 5e-1 9e-1 1e1]" 90 10 




