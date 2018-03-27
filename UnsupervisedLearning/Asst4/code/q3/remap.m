function [new,word_map] = remap(w)
word=1;word_map=[];
for ww=1:length(w)
    if isempty(find(word_map==w(ww)))
        word_map(word) = w(ww);
        new(ww) = word; 
        word=word+1;
    else
        tmp = find(word_map==w(ww));
        new(ww) = tmp(1);
    end
end