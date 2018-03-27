function [mu sigma, pie,lambda,F_his] = LearnBinFactors(X,K,iterations)
[N,D] = size(X);
[Message0,mu,sigma,pie] = initial_para(X,N,D,K);

F_last = -inf;
thres = 10^-10;   % convergence criterion to stop iteration

F_his = zeros(iterations,1);

for j=1:iterations
   % Implement E step
   [lambda,Message,~] = LBP(X,mu,sigma,pie,Message0,50); 
   
   % Implement M step
   ES = lambda;
   ESS = zeros(N,K,K);
   for n=1:N
     tmp = lambda(n,:)'*lambda(n,:);
     tmp(logical(eye(K)))=lambda(n,:);
     ESS(n,:,:) = tmp;
   end
   [mu, sigma, pie] = MStep(X,ES,ESS);
   
   F = FreeEnergy(X,mu,sigma,pie,lambda);
   fprintf('iteration %d :  %f\r',j,F);
   F_his(j) = F;
    % check convergence
    if abs(F-F_last) <  thres
         break;
    end
    F_last = F;
    Message0 = Message;
end
end