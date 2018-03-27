function [zi,Adk,Bkw,Nd,Mk] = gibbs_update(zi,Adk,Bkw,Mk,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);
% collapsed gibbs update

    for ii = 1:I
        pii = zeros(1,K); % pii is the gibbs sampling conditional distribution
        for k=1:K
           pii(k) = (alpha+Adk(di(ii),k)-sum(zi{ii}==k))*(beta+Bkw(k,wi(ii))-sum(zi{ii}==k))...
               /(K*alpha+Nd(di(ii))-sum(zi{ii}==k))/(W*beta+Mk(k)-sum(zi{ii}==k));
        end
        pii = pii/sum(pii);  % nomalize pii, should be a k-dim vector
        
        % Resample zi{ii}
        ser = mnrnd(1,pii,ci(ii));
        [~,index]=max(ser,[],2);
        zi{ii} = index';    
    end
    % update Adk,Bkw,Nd,Mk.
    Adk = zeros(size(Adk));       
    for ii = 1:I
        for k=1:K
          Adk(di(ii),k)= Adk(di(ii),k)+sum(zi{ii}==k);
        end
    end
    Nd = sum(Adk,2);
    Bkw = zeros(size(Bkw));       
    for ii = 1:I
        for k=1:K
          Bkw(k,wi(ii))= Bkw(k,wi(ii))+sum(zi{ii}==k);
        end
    end
    Mk = sum(Bkw,2);
end