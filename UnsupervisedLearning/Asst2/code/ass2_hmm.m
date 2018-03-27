clc,clear all;
a='AABBBACABBBACAAAAAAAAABBBACAAAAABACAAAAAABBBBACAAAAAAAAAAAABACABACAABBACAAABBBBACAAABACAAAABACAABACAAABBACAAAABBBBACABBACAAAAAABACABACAAABACAABBBACAAAABACABBACA'
count_AA = 0;
for i=2:160 
    if(a(i)=='A' && a(i-1)=='A') 
        count_AA=count_AA+1;
    end
end
count_AB = 0;
for i=2:160 
    if(a(i)=='B' && a(i-1)=='A') 
        count_AB=count_AB+1;
    end
end
count_BB = 0;
for i=2:160 
    if(a(i)=='B' && a(i-1)=='B') 
        count_BB=count_BB+1;
    end
end
count_BA = 0;
for i=2:160 
    if(a(i)=='A' && a(i-1)=='B') 
        count_BA=count_BA+1;
    end
end
