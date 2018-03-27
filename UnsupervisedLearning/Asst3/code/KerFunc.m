function k = KerFunc(s,t,para)

theta = para(1);
tao = para(2);
sigma = para(3);
fi = para(4);
eta = para(5);
kesai = para(6);

k = kesai^2*(s==t) + theta^2*(exp(-2*(sin(pi*(s-t)/tao))^2/sigma/sigma)+fi^2*exp(-(s-t)^2/2/eta/eta));
end