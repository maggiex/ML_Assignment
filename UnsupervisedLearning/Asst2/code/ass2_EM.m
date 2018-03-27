% Assignment 2.1, Unsupervised Learning, UCL 2017
% EM algorithm

ll_his=[];
% iteration conditions
iter_max = 1000;
min_con = -100;

% input
K=2;
% load the data set
load binarydigits.txt -ascii;
X = binarydigits';
[D,N]=size(X);

% initial parameters
PI = rand(1,K);
PI = PI/sum(PI);

P = rand(K,D);

% initial log-likelihood
[lh_log,R_tmp] = compute_ll(X,PI,P);
fprintf('Initial Log-Likelihood is %f\n',lh_log);
ll_his = lh_log;

% EM iteration
iter = 0;
while(1)
    % E-step
    R = (bsxfun(@rdivide, R_tmp', sum(R_tmp')))';
    
    % M-step
    PI = sum(R)/N;
    P = (X*bsxfun(@rdivide, R, sum(R)))';
    
    % Compute log-likelihood
    [nlh_log,R_tmp] = compute_ll(X,PI,P);
    
    % display and prepare for next iter or exit circle. 
    fprintf('Iteration %d: Log-Likelihood is %f\n',iter+1,nlh_log);
    ll_his = [ll_his nlh_log];
    if(nlh_log -lh_log < min_con || iter >= iter_max-1) break;
    else
        lh_log = nlh_log;
        iter = iter+1;
    end
end

if(iter>=iter_max-1)
    fprintf('Iteration times overflow.\n');
else
    fprintf('Accuracy reach.\n');
    display(PI);
end

% % cluster means
% cluster_mean = bsxfun(@rdivide, X*R,sum(R));
% %figure,
% for k=1:K
% %   subplot(1,K,k);
%     ck = cluster_mean(:,k); 
%     colormap gray;
%     %imagesc(reshape(ck,8,8)');
% end
