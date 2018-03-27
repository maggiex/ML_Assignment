% estimate transition stastics using <war and peace>
clc,clear;

% read symbols
fid = fopen('symbols.txt','rb');
symbols = fgetl(fid);
while(~feof(fid))
    symbol = fgetl(fid);
    symbols=[symbols;symbol];
end
fclose(fid);

% maximum likelihood to estimate transition matrix
S = length(symbols);
T = ones(S+1,S+1);  % add one symbol for accident.
fid = fopen('war&peace.txt','rb');
txt = fgetl(fid);
T = UpdateT(T,txt,symbols);
if(length(txt)>0) last = txt(end);else last = []; end
while(~feof(fid))
   txt = fgetl(fid);
   txt2 = [last txt];
   T = UpdateT(T,txt2,symbols);
   if(length(txt)>0) last = txt(end);else last = []; end
end
fclose(fid);
T = T(1:end-1,1:end-1); % ignore the strange symbols(like French words.)
Tnorm = diag(1./sum(T'),0)*T;  % makes row sum = 1;
Tnorm(isnan(Tnorm)) = 0;
figure,imagesc(Tnorm),colormap(flipud(gray));
xlabel('second letter');ylabel('first letter');

% calculate stationary distribution
[V,D] = eig(Tnorm');
d = diag(D);
[~,ii] = min(abs(d-1));
pi = V(:,ii)';
pi = pi/sum(pi);
figure,imagesc(pi),colormap(flipud(gray));
xlabel('letters stationary distribution');


