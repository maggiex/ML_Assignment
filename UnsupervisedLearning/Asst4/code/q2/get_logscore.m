function ss = get_logscore(message,sigma,T,symbols)
ss = 0;
len = length(message);
for i=1:(len-1)
    si = find(sigma==message(i));
    sj = find(sigma==message(i+1));
    if(si>length(symbols) || sj>length(symbols) || length(si)==0 || length(sj)==0) 
    else
        ss = ss + log(T(si,sj));
    end
end