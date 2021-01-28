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

res = svmtrain(xl,X,'-t 0 -c 1');
multiplicadoresLagrange = abs (res.sv_coef);
vectoresSoporte = X(res.sv_indices,:);
theta = res.sv_coef' *X(res.sv_indices,:);
theta0 = sign(res.sv_coef(1)) - theta * res.SVs(1,:)';
margen = 2/norm(theta);
tol = 1-sign(res.sv_coef).*(res.SVs*theta' + theta0);
x1 = [0:7];
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2);
m1 = -theta(1)/theta(2)*x1 - (theta0-1)/theta(2);
m2 = -theta(1)/theta(2)*x1 - (theta0+1)/theta(2);
plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"ob",X(res.sv_indices,1),X(res.sv_indices,2),"xk",x1,x2,"-k",x1,m1,"-g",x1,m2,"-b","markersize",20);
axis([0 7 0 7]);
cadena = sprintf("margin = %f",margen);
%test(1.0,6.25,cadena);
text(res.SVs(3,1)+0.15,res.SVs(3,2),sprintf("%3.1f",tol(3)));
print -deps -color svm2.eps;
