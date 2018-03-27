function Y = tfidf( X )
% FUNCTION computes TF-IDF weighted word histograms.
%   Y = tfidf( X );
% INPUT : X  - document-term matrix (rows represent documents, columns represent words)
% OUTPUT :Y  - TF-IDF weighted document-term matrix
 
% get term frequencies
tf_X = tf(X);     % still matrix D*W
% get inverse document frequencies
idf_X = idf(X);   % vector, W elements
% apply weights for each document
Y = tf_X;
for j=1:size(X, 2)
    Y(:, j) = tf_X(:, j)*idf_X(j);
end
 
function tf_X = tf(X)
% FUNCTION computes word frequencies
 tf_X = zeros(size(X));
for i=1:size(X, 1)
    x = X(i, :);
    sumX = sum(x);
%   tf_X(i, :) = 0.5+0.5*x/max(x);   
    if sumX ~= 0
        tf_X(i, :) = x / sum(x);
    else
        tf_X(i, :) = 0;
    end 
end
 
function I = idf(X)
% FUNCTION computes inverse document frequencies
% m - number of documents
% n - number of words
[m, n]=size(X);
 
I = zeros(n, 1);
for j=1:n
    % count non-zero frequency words
    nz = 1 + nnz( X(:, j) );
    % if not zero, assign a weight:
    if nz
        I(j) = log(m/nz) / log(m);
    end
end