function L = stdgibbs_logjoint(theta,phi,Adk,Bkw,Mk,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);
% standard gibbs log joint probability over everything
     
    prior_dk = D*(log(gamma(K*alpha))-K*log(gamma(alpha)));
    prior_kw = K*(log(gamma(W*beta))-W*log(gamma(beta))); 
    dk_ll = sum(sum((alpha-1+Adk).*log(theta)));
    kw_ll = sum(sum((beta-1+Bkw).*log(phi)));
    L = prior_dk + dk_ll + prior_kw + kw_ll;

end
