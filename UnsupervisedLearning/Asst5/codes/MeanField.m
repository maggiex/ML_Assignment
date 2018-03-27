function [lambda,F] = MeanField(X,mu,sigma,pie,lambda0,maxsteps)
% Variational Estep for our models.
% 
% Inputs:
% mu: D ¡Á K matrix of means
% pie: 1 ¡Á K vector of priors on s
% lambda0: initial values for lambda
% maxsteps: maximum number of steps of the fixed point equations.
% 
% Outputs:
% lambda: N¡ÁK distributions on latent variables
% F: lower bound on the likelihood
% X: N ¡ÁD data matrix
[N,D] = size(X);
[~,K] = size(lambda0);
thres = 10^-9;   % convergence criterion to stop iteration

self_m = diag(mu'*mu)';   % self product for mu
self_X = sum(sum(X.*X));  % self product for X

% Computer Free Energy without updates lambda
index = find(lambda0>0 & lambda0<1);   % to avoid numerical problems in entropy computations
F = sum(log(pie./(1-pie))*lambda0') ...
        + N*sum(log(1-pie))...
        -N*D/2*log(2*pi*sigma*sigma)...
        -(self_X-2*sum(sum(X.*(lambda0*mu')))...
        +sum(sum((lambda0*mu').^2))-sum(sum(lambda0.^2.*repmat(self_m,N,1)))...
        +sum(sum(lambda0.*repmat(self_m,N,1))))...
        /(2*sigma*sigma)...
        -sum(sum(lambda0(index).*log(lambda0(index))+(1-lambda0(index)).*log(1-lambda0(index))));
% fprintf('iteration 0 :  %f\r',F);
lambda = lambda0;

for j= 1:maxsteps
%% Update lambda
     current_lambda = lambda; 
     for k = 1:K
         tmp = log(repmat(pie(k)/(1-pie(k)),N,1))...
             +((2*X-2*current_lambda*mu')*mu(:,k)+2*current_lambda(:,k).*repmat(self_m(k),N,1)-repmat(self_m(k),N,1))/(2*sigma*sigma);
     current_lambda(:,k) = 1./(1+exp(-tmp));   
     end      
     
%%  Compute Free Energy
    index = find( current_lambda>0 & current_lambda<1);
    current_F = sum(log(pie./(1-pie))*current_lambda') ...
        + N*sum(log(1-pie))...
        -N*D/2*log(2*pi*sigma*sigma)...
        -(self_X-2*sum(sum(X.*(current_lambda*mu')))...
        +sum(sum((current_lambda*mu').^2))-sum(sum(current_lambda.^2.*repmat(self_m,N,1)))...
        +sum(sum(current_lambda.*repmat(self_m,N,1))))...
        /(2*sigma*sigma)...
        -sum(sum(current_lambda(index).*log(current_lambda(index))))-sum(sum((1-current_lambda(index)).*log(1-current_lambda(index))));
%        fprintf('iteration %d :  %f\r',j,current_F);
 
%%  check if F increases after update
    if current_F-F < thres;
          break;
    end
    F = current_F;
    lambda = current_lambda;
end
end