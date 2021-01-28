function [errorY] = mlp(Xtr,xltr,Xdv,xldv,Y,yl,nHidden,epochs,show,seed)
Xtr = Xtr'; xltr = xltr'; Xdv = Xdv'; xldv = xldv'; Y = Y'; yl = yl';
[Xtrnorm,Xtrmean,Xtrstd] = prestd(Xtr);
XdvNN.P = trastd(Xdv,Xtrmean,Xtrstd);
XdvNN.T = onehot(xldv);
nOutput = numel(unique(xldv)); %nOutput es el numero de clases
initNN = newff(minmax(Xtrnorm),[nHidden nOutput],{"tansig","logsig"},"trainlm","","mse");
initNN.trainParam.show = show;
initNN.trainParam.epochs = epochs;
rand("seed",seed);
NN = train(initNN, Xtrnorm, onehot(xltr),[],[],XdvNN);

Ynorm = trastd(Y,Xtrmean,Xtrstd);
Yout=sim(NN,Ynorm);
[nfilas, posMax]  = max(Yout); %vector donde cada elemento es el valor maximo de la muestra y

classes = unique(xltr);
errorY = mean(classes(posMax)!=yl)*100;
endfunction



function xloh=onehot(xl)
  classes = unique(xl);
  C = numel(classes);
  for c=1:C
    xloh(c,:) = (classes(c) == xl);
  endfor
endfunction
