function F = FreeEnergy(X,mu,sigma,pie,lambda0)
% Variational Estep for our models.
% 
% Inputs:
% mu: D ¡Á K matrix of means
% pie: 1 ¡Á K vector of priors on s
% lambda0: initial values for lambda

% Outputs:
% F: lower bound on the likelihood
[N,D] = size(X);

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
