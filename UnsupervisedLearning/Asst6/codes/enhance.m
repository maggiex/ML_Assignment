function mu_eh = enhance(mu)
 mu_eh = zeros(size(mu));
 mu_eh(find(mu>0.3))=1;
end