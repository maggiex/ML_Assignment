% clc,clear;
% load the data set
load co2.txt -ascii;

% input points
X = (co2(:,1)+(co2(:,2)-1)/12)';
Y = co2(:,3)';
res = Y-w_mean'*[X;ones(1,length(X))];
% prediction years
X_new = [X(end):1/12:2021];
X_new = X_new(2:end-1);

% all inputs
X_all = [X X_new];

l_a = length(X);
l_b = length(X_new);
l = l_a + l_b;

% kernal funciton parameters
para = [3,1,2,0.5,4,0.05];
% para = [1.85,1,1.3,0.52,1.36,0.05];

mean = zeros(1,l);
cov = zeros(l,l);

% generate covariance 
for i=1:l
    for j=1:l
        cov(i,j) = KerFunc(X_all(i),X_all(j),para);
    end
end

% compute b|a 's mean and variance
Kaa = cov(1:l_a,1:l_a);
Kab = cov(1:l_a,l_a+1:end);
Kba = cov(l_a+1:end,1:l_a);
Kbb = cov(l_a+1:end,l_a+1:end);

mean_new = (Kba*(Kaa^-1)*res')';
cov_new = Kbb-Kba*(Kaa^-1)*Kab;

% compute b|a
res_new = GenerateSamples(mean_new,cov_new);
Y_new = res_new + w_mean'*[X_new;ones(1,length(X_new))];

% Draw sample of predictive residual function. 
figure,plot(res_new);hold on;

% Plot the whole CO2 values.
figure,
plot(X,Y); hold on;
plot(X_new,Y_new);hold on;

% Plot the means and one standard deviation error bars
Y_new2 = mean_new + w_mean'*[X_new;ones(1,length(X_new))];
% means 
figure,plot(X_new,Y_new2,'r');hold on;
% 1-sd
sigma = sqrt(diag(cov_new));
% follow rectangle order to draw error bars
patch([X_new';flipud(X_new')],[Y_new2'+sigma;flipud(Y_new2'-sigma)],'b','FaceA',0.1,'EdgeA',0); 
    

