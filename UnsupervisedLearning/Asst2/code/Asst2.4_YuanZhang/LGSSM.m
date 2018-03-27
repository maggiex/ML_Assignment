clc,clear;

% read data
load ssm_spins.txt -ascii;
X = ssm_spins';

% parameters settings
angle = 2*pi/180;
A = 0.99*[cos(angle) -sin(angle) 0 0; sin(angle) cos(angle) 0 0; 0 0 cos(2*angle) -sin(2*angle); 0 0 sin(2*angle) cos(2*angle)];
Q = eye(size(A)) - A*A';
C = [1   0   1   0;
     0   1   0   1;
     1   0   0   1;
     0   0   1   1;
     0.5 0.5 0.5 0.5];
[dd,~] = size(C);
R = eye(dd,dd);
[kk,~] = size(A);
Y0 = zeros(kk,1);
Q0 = eye(kk,kk);

% define a logdet function
logdet = @(A)(2*sum(log(diag(chol(A)))));

% kalman algorithm
[Y,V,~,L] = ssm_kalman(X,Y0,Q0,A,Q,C,R,'filt');
figure,plot(Y');
figure,plot(cellfun(logdet,V));
      
[Y2,V2,Vj2,L2] = ssm_kalman(X,Y0,Q0,A,Q,C,R, 'smooth');
figure,plot(Y2');
figure,plot(cellfun(logdet,V2));
