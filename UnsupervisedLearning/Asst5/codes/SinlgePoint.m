X = Y(1,:);
[N,D] = size(X);
% lambda0 = rand(N,K);
lambda0 = lambda(N,:);
mu = mu';

iterations = 50;
sig = [4 2 1];

F3 = zeros(3,iterations+1);
for i = 1:3
    sigma = sig(i);
    [lambda,F0] = MeanField(X,mu,sigma,pie,lambda0,0);
    F = F0;
for j=1:iterations 
   % Implement E step
   [lambda,Ftmp] = MeanField(X,mu,sigma,pie,lambda,1);
   F = [F Ftmp];
end
   F3(i,:) = F;
end
F3 = F3';
figure,plot(F3);
title('Free Energy for MeanField');xlabel('iterations');
h = legend('sigma=4','sigma=2','sigma=1');set(h,'fontsize',18);

set(h,'fontsize',12);
diff = log(abs(F3(2:end,:)-F3(1:end-1,:)));
diff(find(diff==-inf))=-100;
figure,plot(diff);
title('Differences of Free Energy for MeanField');xlabel('iterations');legend('sigma=1','sigma=0.6','sigma=0.2');
h = legend('sigma=4','sigma=2','sigma=1');set(h,'fontsize',18);
