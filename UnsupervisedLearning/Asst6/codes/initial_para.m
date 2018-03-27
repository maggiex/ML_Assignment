function [Message0,mu,sigma,pie] = initial_para(X,N,D,K)

% random generate natural parameters of lambda
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


% random generate Message matrix
Message0 = rand(K,K,N);
for n=1:N
    b = Message0(:,:,n);
    b = b-diag(diag(b));
    Message0(:,:,n) = b;
end