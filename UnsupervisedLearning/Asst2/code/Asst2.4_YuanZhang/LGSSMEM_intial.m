function [A,Q,C,R,Q0,Y0]=LGSSMEM_intial(rand)
% if rand==1 generate random initial parameters, else we use parametes from
% the assignment.
if rand == 1
    k = 4;
    d = 5;
    A = randn(k,k);
    Q = iwishrnd(eye(k),k);
    C = randn(d,k);
    R = iwishrnd(eye(d),d);
    Y0 = randn(k,1);
    Q0 = iwishrnd(eye(k),k);
else if rand==2
angle = 2*pi/180;
A = 0.99*[cos(angle) -sin(angle) 0 0; sin(angle) cos(angle) 0 0; 0 0 cos(2*angle) -sin(2*angle); 0 0 sin(2*angle) cos(2*angle)];
Q = eye(size(A)) - A*A';
C = [1   0   1   0;
     0   1   0   1;
     1   0   0   1;
     0   0   1   1;
     0.5 0.5 0.5 0.5];
dd = size(C,1);
R = eye(dd,dd);
kk = size(A,1);
Y0 = zeros(kk,1);
Q0 = eye(kk,kk);
    else
        HoKalman;
        A=Ahat;Q=Qhat;C=Chat;R=Rhat;kk = size(A,1);Y0 = zeros(kk,1);Q0 = eye(kk,kk);
    end
end