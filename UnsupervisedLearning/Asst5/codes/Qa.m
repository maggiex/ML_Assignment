K = 8;
iterations = 200;
[mu, sigma, pie,lambda] = LearnBinFactors(Y,K,iterations);

% plot mu
mu = mu';

figure,
set(gcf,'Color',[0.2 0.4 0.6]); % Background color
colormap gray;
for k=1:K
    subplot(2,4,k);
    imagesc(reshape(mu(k,:),4,4),[0 2]);
    axis off;
    axis equal;
end

% plot mu after image enhancement
mu_eh = enhance(mu);

figure,
set(gcf,'Color',[0.2 0.4 0.6]); % Background color
colormap gray;
for k=1:K
    subplot(2,4,k);
    imagesc(reshape(mu_eh(k,:),4,4),[0 2]);
    axis off;
    axis equal;
end
