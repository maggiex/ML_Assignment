function[I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,word_map] = data_prune(W_ex,I,D,K,W,di,wi,ci,citest,Id,Iw,Nd)

% read symbols
fid = fopen('nips.vocab','rb');
words{1} = fgetl(fid);
j=2;
while(~feof(fid))
    word = fgetl(fid);
    words{j} = word;
    j=j+1;
end
fclose(fid);

% generate frequency matrix, times of word w in document d
Freq = zeros(D,W);
for ii=1:I
   Freq(di(ii),wi(ii)) =  Freq(di(ii),wi(ii))+ci(ii);
end

% using tfidf to calculate weights of words
weights = tfidf(Freq);
tmp = weights;
keep = zeros(W,1);
count = 0;

% selected first W_ex important words
while(count<W_ex)
      [~,ddd] = max(sum(tmp));
      tmp(:,ddd)=0;
      keep(ddd)=1;
      count = nnz(keep);
      display(words{ddd});
end

% updata I, di, wi, ci, citest
In=0;din=[];win=[];cin=[];citestn=[];
for ii=1:I
   if keep(wi(ii))==1 
        In = In+1;
        din = [din di(ii)];
        win = [win wi(ii)];
        cin = [cin ci(ii)];
        citestn = [citestn citest(ii)];
   end
end
[win,word_map] = remap(win); % remember the mapping between reduced words and original words
di = din; ci = cin; wi = win; citest = citestn;I=In;

% update other variables
D  = max(di);
W  = max(wi);
X = sparse(di,wi,1:I,D,W,I);
Id = cell(1,D);
Nd = zeros(1,D);
Iw = cell(1,W);
for ww = 1:W
  ii = find(X(:,ww));
  Iw{ww} = full(X(ii,ww));
end
X = X';
for dd = 1:D
  ii = find(X(:,dd));
  Id{dd} = full(X(ii,dd));
  Nd(dd) = sum(ci(Id{dd}));
end
end