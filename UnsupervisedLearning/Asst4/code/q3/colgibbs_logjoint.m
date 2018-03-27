function L = gibbs_loglik(Adk,Bkw,Mk,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);
% collapsed gibbs log joint probability over everything

    prior_dk = D*(log(gamma(K*alpha))-K*log(gamma(alpha)))-sum(log(gamma(K*alpha+Nd)));
    prior_kw = K*(log(gamma(W*beta))-W*log(gamma(beta)))-sum(log(gamma(W*beta+Mk)));
    dk_ll = sum(sum(log(gamma(alpha+Adk))));
    kw_ll = sum(sum(log(gamma(beta+Bkw))));
    L = prior_dk + dk_ll + prior_kw + kw_ll;

end