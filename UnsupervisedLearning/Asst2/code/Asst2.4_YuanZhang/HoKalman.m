% Assignment 2.4, Unsupervised Learning, UCL 2017
% HoKalman-SSID algorithm

% iteration conditions
iter_max = 100;
min_con = 1e-12;

% basic settings
maxlag = 10;
k = 4; %latent dimension
Y0 = zeros(k,1);
Q0 = eye(k,k);

% input
% read data
load ssm_spins.txt -ascii;
X = ssm_spins';
[d,T]=size(X);

% define sum of cells.
cellsum=@(C)(sum(cat(3,C{:}),3));

% start Ho-Kalman
% build coreelation matrices M
for tao=1:2*maxlag-1
    M(tao) = {X(:,1+tao:T)*X(:,1:T-tao)'./(T-tao)};
end

% Decomposition
H = cell2mat(M(hankel([1:maxlag],[maxlag:2*maxlag-1])));
[Xi,SV,Ups] = svds(H, k);   % print SV
Xi = Xi*sqrt(SV);
Ups = sqrt(SV)*Ups';

Ahat = Xi(1:end-d,:)\Xi(d+1:end,:);
Chat = Xi(1:d,:)/Ahat^0;
for l=1:maxlag-1
    Chat = Chat + Xi(1+d*l:d*(l+1),:)/Ahat^l;
end
Chat = Chat/maxlag;
Phat = 0;
for l=1:maxlag
    Phat = Phat + Ahat\Ups(:,1+(l-1)*d:d*l);
end
Phat = Phat/maxlag;
Phat = Phat/Chat';
Qhat = Phat-Ahat*Phat*Ahat';
Rhat = X*X'-Chat*Phat*Chat';

[Y,V,Vj,L] = ssm_kalman(X,Y0,Q0,Ahat,Qhat,Chat,Rhat,'smooth');
ll = sum(L);
fprintf('Ho-Kalman Initial Log-Likelihood is %f\n',ll);