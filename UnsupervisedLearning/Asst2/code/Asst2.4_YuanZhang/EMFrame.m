% framework of EM LGSSM
clc,clear;

ll_train=[];
ll_test=[];

% true value
[ll,test] = LGSSMEM(2);
ll_train =[ll_train;ll];
ll_test = [ll_test;test];

% random value
for i=1:10
    [ll,test] = LGSSMEM(1);
    ll_train =[ll_train;ll];
    ll_test = [ll_test;test];
end

% SSID
[ll,test] = LGSSMEM(3);
ll_train =[ll_train;ll];
ll_test = [ll_test;test];

save('FinalResult.mat', 'll_train', 'll_test');

% plot train likelihood
figure,
plot(ll_train(1,:),'--r');hold on;
for i=2:11
    plot(ll_train(i,:),'g');hold on;
end
plot(ll_train(12,:),'xb');hold on;
scatter(1,ll_train(12,1),40,'MarkerFaceColor',[0 0 1]);

% % add test likelihood on
% for i=2:11
% scatter(1,ll_test(i,1),100,'ks');
% scatter(101,ll_test(i,2),100,'ks');
% end
% scatter(1,ll_test(1,1),100,'rs');
% scatter(101,ll_test(1,2),100,'rs');
% scatter(1,ll_test(12,1),100,'bs');
% scatter(101,ll_test(12,2),100,'bs');