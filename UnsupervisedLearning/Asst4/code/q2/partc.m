% partc
iteration = 100000;

% read descrypted messages
message=fileread('message.txt');
mlen = length(message);

% initilize the mappings 
% we can use some intuitions. such as ' ' and 'e' have the largest
% frequency.
sig = symbols;
distribute = tabulate(message');
fre = [distribute{:,2}]; cha = [distribute{:,1}];
[~,space_pos] = max(fre);
space_map = cha(space_pos);
fre(space_pos)=0;
[~,e_pos] = max(fre);
e_map = cha(e_pos);
sig(find(symbols==' ')) = space_map;
sig(find(symbols==space_map)) = ' ';
sig(find(symbols=='e')) = e_map;
sig(find(symbols==e_map)) = 'e';

% run MH samples
for i=1:iteration
    signew = generate_sig(sig);
    ls_sig = get_logscore(message,sig,Tnorm,symbols);
    ls_signew = get_logscore(message,signew,Tnorm,symbols);   
    accept = exp(ls_signew-ls_sig);
    rand = rand(1);
    if rand <= min(accept,1)
      sig = signew;
    end
    if(mod(i,100)==0) 
        % decoded message 
        message_d = message;
        for k=1:mlen
            id = find(sig==message(k));
            message_d(k)= symbols(id);
        end
        display(strcat('iteration ',num2str(i),': ',message_d(1:min(60,mlen))));
    end
end

