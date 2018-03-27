function Tnew =  UpdateT(T,txt,symbols)
% calculate this new line and update our transition matrix
len = length(txt);
Tnew = T;
if(len==0) return; end
S = length(symbols);
states = zeros(len,1);
for i=1:len
    id = find(symbols==txt(i));
    if(isempty(id))
        states(i) = S+1;
    else
          states(i) = id;
    end
end
for i=1:length(states)-1
    m = states(i);
    n = states(i+1);
    Tnew(m,n) = T(m,n)+1;
end
end


