#!/usr/bin/octave -qf

addpath("svm_apr");

if (nargin!=2)
printf("Usage: svm2.m <trdata> <trlabels>\n")
exit(1);
end;

arg_list=argv();
trdata=arg_list{1};
trlabs=arg_list{2};

load(trdata);
load(trlabs);

res = svmtrain(xl,X,'-t 0 -c 1000');
multiplicadoresLagrange = abs(res.sv_coef);
vectoresSoporte = X(res.sv_indices,:);
theta = res.sv_coef'*X(res.sv_indices,:);
theta0 = sign(res.sv_coef(1)) - theta * res.SVs(1,:)';
margen = 2/norm(theta);
x1 = [0:7];
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2);
plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"ob",X(res.sv_indices,1),X(res.sv_indices,2),"xk",x1,x2,"-k");
axis([0 7 0 7]);
print -deps -color svm21.eps;
