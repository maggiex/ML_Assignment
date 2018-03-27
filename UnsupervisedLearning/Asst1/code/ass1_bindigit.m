% Assignment 3, Unsupervised Learning, UCL 2003
% Zoubin Ghahramani
% Matlab comments start with %

% load the data set

load binarydigits.txt -ascii;
Y=binarydigits;
[N D]=size(Y);

% this is how you display one image, e.g. the 4th image:
%
% y=Y(4,:);
% colormap gray;
% imagesc(reshape(y',8,8)')

% you can also reshape by hand as follows (slower, but useful for
% non-Matlab implementations)
% for i=1:8,
%  for j=1:8,
%    x(i,j)=y((i-1)*8+j);
%  end;
% end;

% now we will display the whole data set:
colormap gray;
for n=1:N, 
  subplot(10,10,n);
  imagesc(reshape(Y(n,:)',8,8)'); 
  axis off;
end;


% ML parameters of a multivariate Bernoulli
p_ml = sum(Y)/N; 
figure,colormap gray;imagesc(reshape(p_ml',8,8)'); 

% MAP parameters of a multivariate Bernoulli
a = 3; b=3;
p_map = sum(Y)/(a+b-2+N)+ones(1,D)*(a-1)/(a+b-2+N); 
figure,colormap gray;imagesc(reshape(p_map',8,8)'); 

figure,
plot(p_ml);hold on;
plot(p_map,'-.');hold on;
legend('p_m_l','p_m_a_p');