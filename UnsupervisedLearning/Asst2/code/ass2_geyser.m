% load the data set
load geyser.txt -ascii;

% plot variables within time steps
figure,
plot(geyser(:,1),geyser(:,2),'o');
% plot variables between time steps
figure,
for n=0:294
plot(geyser(1:end-n,1),geyser(n+1:end,1),'o');
axis([0 max(geyser(:,1)) 0 max(geyser(:,1))]);
end