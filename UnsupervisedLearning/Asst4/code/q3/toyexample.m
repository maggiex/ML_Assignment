clc,clear;
% run both standard and collapsed gibbs on the toy example consisting of
% 6 documents, 6 words, and 3 topics.  The true word distribution for each
% topic should be:
% [.5 .5 0 0 0 0], [0 0 .5 .5 0 0], [0 0 0 0 .5 .5]

K = 3;             % number of topics
alpha = 1;         % dirichlet prior over topics
beta =  1;         % dirichlet prior over words
numiter = 200;     % number of iterations

[I,D,K,W,di,wi,ci,citest,Id,Iw,Nd] = lda_read('toyexample.data',K);

[zi,theta,phi] = lda_randstate(I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);

[zistdgibbs theta phi Adk Bkw Mk Lstdgibbs Pstdgibbs Tstdgibbs] ...
        = stdgibbs_run(zi,theta,phi,numiter,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);

[zicolgibbs Adk Bkw Mk Lcolgibbs Pcolgibbs Tcolgibbs] ...
        = colgibbs_run(zi,numiter,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);
figure,
subplot(221); plot(1:numiter+1,Pstdgibbs); title('std gibbs log pred');hold on;
subplot(222); plot(1:numiter+1,Lstdgibbs); title('std gibbs log joint');hold on;
subplot(223); plot(1:numiter+1,Pcolgibbs); title('col gibbs log pred');hold on;
subplot(224); plot(1:numiter+1,Lcolgibbs); title('col gibbs log joint');hold on;

% % autocorrelation
% x1=Pstdgibbs(25:end);
% x2=Lstdgibbs(25:end);
% y1=Pcolgibbs(20:end);
% y2=Lcolgibbs(20:end);
% 
% figure,
% subplot(221); autocorr(x1,length(x1)-1); title('std gibbs log pred autocorr');
% subplot(222); autocorr(x2,length(x2)-1); title('std gibbs log joint autocorr');
% subplot(223); autocorr(y1,length(y1)-1); title('col gibbs log pred autocorr');
% subplot(224); autocorr(y2,length(y2)-1); title('col gibbs log joint autocorr');
