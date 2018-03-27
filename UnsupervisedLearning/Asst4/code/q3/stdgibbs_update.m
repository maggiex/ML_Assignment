function [zi,theta,phi,Adk,Bkw,Nd,Mk] = stdgibbs_update(zi,theta,phi,Adk,Bkw,Mk,...
        I,D,K,W,di,wi,ci,citest,Id,Iw,Nd,alpha,beta);
% standard gibbs update

    for ii = 1:I
        pii = theta(di(ii),:)' .* phi(:,wi(ii)); % pii is the gibbs sampling conditional distribution
        pii = pii/sum(pii);  % nomalize pii, should be a k-dim vector
        % Resample zi{ii}
        ser = mnrnd(1,pii,ci(ii));
        [~,index]=max(ser,[],2);
        zi{ii} = index';   
    end

    % updata Adk
    Adk = zeros(size(Adk));       
    for ii = 1:I
        for k=1:K
          Adk(di(ii),k)= Adk(di(ii),k)+sum(zi{ii}==k);
        end
    end
    % Resample doc topic distribution
    for d=1:D
      theta(d,:) = drchrnd(1,alpha + Adk(d,:)); 
    end
    Nd = sum(Adk,2);
    
    % updata Bkw
    Bkw = zeros(size(Bkw));       
    for ii = 1:I
        for k=1:K
          Bkw(k,wi(ii))= Bkw(k,wi(ii))+sum(zi{ii}==k);
        end
    end
    % Resample topic word distribution
    for k=1:K
      phi(k,:) = drchrnd(1,beta + Bkw(k,:));
    end
    Mk = sum(Bkw,2);
    
end

