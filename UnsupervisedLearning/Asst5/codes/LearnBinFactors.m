function [mu, sigma, pie,lambda0] = LearnBinFactors(X,K,iterations)
[N,D] = size(X);
[lambda0,mu,sigma,pie] = initial_para(X,N,D,K);

F_last = -inf;
thres = 10^-100;   % convergence criterion to stop iteration
for j=1:iterations
   % Implement E step
   [lambda,F] = MeanField(X,mu,sigma,pie,lambda0,30);
    
   % Implement M step
   ES = lambda;
   ESS = zeros(N,K,K);
   for n=1:N
     tmp = lambda(n,:)'*lambda(n,:);
     tmp(logical(eye(K)))=lambda(n,:);
     ESS(n,:,:) = tmp;
   end
   [mu, sigma, pie] = MStep(X,ES,ESS);
   
   [lambda,F] = MeanField(X,mu,sigma,pie,lambda,0);
   fprintf('iteration %d :  %f\r',j,F);
     
    if F-F_last <  thres;
         break;
    end
    F_last = F;
    lambda0 = lambda;
end
end