% run both standard and collapsed gibbs on the nips data set

K = 50;             % number of topics
alpha = .1;         % dirichlet prior over topics
beta =  .01;         % dirichlet prior over words
numiter = 200;     % number of iterations
W_ex = 150;        % numbers of words we expected

[I,D,K,W,di,wi,ci,citest,Id,Iw,Nd] = lda_read('nips.data',K);

[I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,word_map] = data_prune(W_ex,I,D,K,W,di,wi,ci,citest,Id,Iw,Nd);

[zi,theta,phi] = lda_randstate(I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);

[zistdgibbs theta phi Adk Bkw Mk Lstdgibbs Pstdgibbs Tstdgibbs] ...
        = stdgibbs_run(zi,theta,phi,numiter,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);

[zicolgibbs Adk Bkw Mk Lcolgibbs Pcolgibbs Tcolgibbs] ...
        = colgibbs_run(zi,numiter,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);

subplot(221); plot(1:201,Pstdgibbs); title('std gibbs log pred');
subplot(222); plot(1:201,Lstdgibbs); title('std gibbs log joint');
subplot(223); plot(1:201,Pcolgibbs); title('col gibbs log pred');
subplot(224); plot(1:201,Lcolgibbs); title('col gibbs log joint');


