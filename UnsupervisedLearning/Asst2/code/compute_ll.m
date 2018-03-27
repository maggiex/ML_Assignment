function [lh_log,R_tmp] = compute_ll(X,PI,P);
% this function is used to calculate log-likelihood and store tempory matrix used for calculating reponsibilities later.
% input:  X - observed data.
%         PI - mixing proportions
%          P - probabilities of Bernoulli
% output:  lh-log - log-likelihood
%           R_tmp - unnormalized responsibilities

    [~,N] = size(X);
    [K,~] = size(P);
    R_tmp = zeros(N,K);
    for n=1:N
        data = X(:,n);
        P_1 = ones(size(P))-P;
        index = find(data==0);
        tmp = P;
        tmp(:,index) = P_1(:,index);
        tmp = tmp';
        tmp_rv = prod(tmp).*PI;
        R_tmp(n,:) = tmp_rv; 
    end
    lh_log = sum(log(sum(R_tmp,2)));
end
