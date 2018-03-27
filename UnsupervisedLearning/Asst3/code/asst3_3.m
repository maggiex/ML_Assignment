clc,clear;
% load the data set
load co2.txt -ascii;

X = (co2(:,1)+(co2(:,2)-1)/12)';
X = [X;ones(1,length(X))];
Y = co2(:,3)';

s_sigma = 1;
Ca = 100;
Cb = 10000;
w = [Ca 0;0 Cb];

w_cov = (X*X'/s_sigma+w^-1)^-1;
w_mean = w_cov*X*Y'/s_sigma;


res = Y-w_mean'*X;
figure,plot(X(1,:),res);
figure,hist(res,100);