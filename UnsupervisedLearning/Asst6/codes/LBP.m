function [lambda,Message,F_last] = LBP(X,mu,sigma,pie,Message0,maxsteps)
% Variational Estep for our models.
% 
% Inputs:
% X: N ¡ÁD data matrix
% mu: D ¡Á K matrix of means
% pie: 1 ¡Á K vector of priors on s
% Message0: N*K*K initial natural parameters of Message passing. 
% maxsteps: maximum number of steps of the fixed point equations.
% 
% Outputs:
% lambda: N¡ÁK distributions on latent variables
% F: lower bound on the likelihood

[N,D] = size(X);
[~,K,~] = size(Message0);
% set new Mnatural parametes.
Message = zeros(size(Message0));


self_m = diag(mu'*mu)';   % self product for mu
self_X = sum(sum(X.*X));  % self product for X

% set natural parameters of fi(si)
f = zeros(N,K);
for n=1:N
   f(n,:) = log(pie./(1-pie)) + X(n,:)*mu/(sigma^2)-self_m/(2*sigma^2);
end


F_last = -inf;
thres = 10^-6;   % convergence criterion to stop iteration

for run= 1:maxsteps
%% Update Message
    for n=1:N
            message_n = Message0(:,:,n);
        for i=1:K
            for j=i+1:K
                
                a=0.5;
           % update Mj->i
              np_old = f(n,j)+sum(message_n(:,j))-message_n(i,j);
              np_true = - mu(:,i)'*mu(:,j)/(sigma^2);
              np_new = (1+exp(np_old+np_true))/(1+exp(np_old));
              % message_n(j,i) = log(np_new);
              message_n(j,i) = a*message_n(j,i) + (1-a)*log(np_new); 
              
           % update Mi->j
              np_old = f(n,i)+sum(message_n(:,i))-message_n(j,i);
              np_true = - mu(:,j)'*mu(:,i)/(sigma^2);
              np_new = (1+exp(np_old+np_true))/(1+exp(np_old));
%             message_n(i,j) = log(np_new);
              message_n(i,j) = a*message_n(i,j) + (1-a)*log(np_new);

            end
        end
        Message(:,:,n) = message_n;
    end
    
    lambda = zeros(N,K);
    for n=1:N 
          np =  f(n,:)+sum(Message(:,:,n));
          lambda(n,:) = 1./(1+exp(-np));
    end
%%  Compute Free Energy
    index = find(lambda>0 & lambda<1);
    F = sum(log(pie./(1-pie))*lambda') ...
        + N*sum(log(1-pie))...
        -N*D/2*log(2*pi*sigma*sigma)...
        -(self_X-2*sum(sum(X.*(lambda*mu')))...
        +sum(sum((lambda*mu').^2))-sum(sum(lambda.^2.*repmat(self_m,N,1)))...
        +sum(sum(lambda.*repmat(self_m,N,1))))...
        /(2*sigma*sigma)...
        -sum(sum(lambda(index).*log(lambda(index))))-sum(sum((1-lambda(index)).*log(1-lambda(index))));
%        fprintf('iteration %d :  %f\r',run,F);
 
%%  check if F increases after update
%     if abs(F-F_last) < thres;
%           break;
%     end
    diff_max = max(max(max((abs(Message-Message0)))));
     if diff_max < thres;
          break;
     end
    
    F_last = F;
    Message0 = Message;
end
end