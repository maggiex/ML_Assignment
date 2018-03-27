% clc,clear;
% load the data set
figure,
plot(X(1,:),res);hold on;
load co2.txt -ascii;

% input points
X = (co2(:,1)+(co2(:,2)-1)/12)';
l = length(X);


% kernal funciton parameters
para = [3,1,2,0.5,4,0.05];

for ll=0:0
mean = zeros(1,l);
cov = zeros(l,l);

% generate covariance 
for i=1:l
    for j=1:l
        cov(i,j) = KerFunc(X(i),X(j),para);
    end
end
% cov = cov + eye(l,l)*s_sigma;

% draw samples randomly
y = GenerateSamples(mean,cov);
plot(X,y); hold on;

end
legend('res','kernel');
