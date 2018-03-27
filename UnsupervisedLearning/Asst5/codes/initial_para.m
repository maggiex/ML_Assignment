function [lambda0,mu,sigma,pie] = initial_para(X,N,D,K)
lambda0 = rand(N,K);

% Use M step to initialize parameters
   ES = lambda0;
   ESS = zeros(N,K,K);
   for n=1:N
     tmp = lambda0(n,:)'*lambda0(n,:);
     tmp(logical(eye(K)))=lambda0(n,:);
     ESS(n,:,:) = tmp;
   end
[mu, sigma, pie] = MStep(X,ES,ESS);
end