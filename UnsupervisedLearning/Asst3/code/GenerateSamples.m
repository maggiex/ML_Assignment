function y = GenerateSamples(mean,cov);
% given mean and cov, generate samples. output is y.

R = chol(cov+eye(size(cov))*0.0000001,'upper');  % plus item is used to avoid unPSD
y = randn(size(mean))*R + mean;

end

