#!/usr/bin/octave -qf

addpath("~/DiscoW/APR/SVM/svm_apr");

if (nargin!=6)
printf("Usage: svm-exp.m <trdata> <trlabels> <t> <c> <%%trper> <%%dvper>\n")
exit(1);
end;

ds = [1 2 3 4 5];

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};
t = str2num(arg_list{3});
c = str2num(arg_list{4});
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
Y= Xdv; yl = xldv;
%vamos a escribir el resultado en un fichero para luego hacer la grafica
f1 = fopen("result.out","w");
for k=1:length(c)
	for j=1:length(t)
		if t(j) == 1
			for i=1:length(ds)
				res = svmtrain(xltr, Xtr, ["-q -t ", num2str(t(j)), " -c ", num2str(c(k)), " -d ", num2str(ds(i))]);
				[pred, accuracy, d] = svmpredict(yl, Y, res, '-q');
				p = accuracy(1) / 100;
	            intervalo = 1.96* sqrt((p * (1-p))/N);
                fprintf(f1,"%d \t %d \t %d \t %3f \t %3f   \n",t(j),c(k),ds(i),p,intervalo);
			endfor
		else
            res = svmtrain(xltr, Xtr, ["-q -t ", num2str(t(j)), " -c ", num2str(c(k))]);
            [pred, accuracy, d] = svmpredict(xldv, Xdv, res, '-q');
            p = accuracy(1) / 100;
	        intervalo = 1.96* sqrt((p * (1-p))/N);
            fprintf(f1,"%d \t %d \t %3f \t %3f   \n",t(j),c(k),p,intervalo);
        endif
	end
	
end
fclose(f1);

%./pca+mixgaussian-exp.m mnist/train-images-idx3-ubyte.mat.gz mnist/train-labels-idx1-ubyte.mat.gz "[1,2,5,10,20,50,100]" "[1e-8 1e-7 1e-6 1e-5 1e-4 1e-3 1e-2 1e-1 2e-1 5e-1 9e-1 1e1]" 90 10 




