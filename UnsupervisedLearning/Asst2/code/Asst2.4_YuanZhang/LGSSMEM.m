% Assignment 2.4, Unsupervised Learning, UCL 2017
% LGSSM-EM algorithm

% iteration conditions
function [ll_his,test] = LGSSMEM(rand)
iter_max = 1000;
tor = 1e-12;

% input
% read data
load ssm_spins.txt -ascii;
X = ssm_spins';
[~,T]=size(X);

% load train data
load ssm_spins_test.txt -ascii;
Xt = ssm_spins_test';

% initial parameters
[A,Q,C,R,Q0,Y0]=LGSSMEM_intial(rand);

% define sum of cells.
cellsum=@(C)(sum(cat(3,C{:}),3));

% store likelihood
[Y,V,Vj,L] = ssm_kalman(X,Y0,Q0,A,Q,C,R,'smooth');
ll = sum(L);
fprintf('Iteration 0: Log-Likelihood is %f\n',ll);
ll_his = ll; lh_log = ll;

% test likelihood
[Yt,Vt,Vjt,Lt] = ssm_kalman(Xt,Y0,Q0,A,Q,C,R,'smooth');
llt = sum(Lt);
test = llt;

% EM iteration
iter = 0;
while(1)
    % E-step
    % just the returen value of kalman.
    
    % M-step
    Eyyn = Y*Y'+cellsum(V);
    Eyy1 = Eyyn - Y(:,end)*Y(:,end)'-cellsum(V(end));
    Eyy2 = Eyyn - Y(:,1)*Y(:,1)'-cellsum(V(1));
    Exy = cellsum(Vj)+Y(:,2:end)*Y(:,1:end-1)';
    
    C = X*Y'/Eyyn;
    A = Exy/Eyy1;
    R = (X*X'-X*Y'*C')/T;
    Q = (Eyy2-Exy*A')/(T-1);
    
    % Compute log-likelihood
    [Y,V,Vj,L] = ssm_kalman(X,Y0,Q0,A,Q,C,R,'smooth');
    ll = sum(L);
    ll_his = [ll_his, ll];
    
    % display and prepare for next iter or exit circle. 
    fprintf('Iteration %d: Log-Likelihood is %f\n',iter+1,ll);
    
    if(iter >= iter_max-1)  break;
    else
        lh_log = ll;
        iter = iter+1;
    end
end
% figure,
% plot(ll_his);
[Yt,Vt,Vjt,Lt] = ssm_kalman(Xt,Y0,Q0,A,Q,C,R,'smooth');
llt = sum(Lt);
test = [test llt];
end
