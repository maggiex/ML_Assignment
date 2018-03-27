tmp = phi;
top5 = zeros(size(phi,1),5); 
for i=1:5
    [mm,index] = max(tmp,[],2);
    top5(:,i) = index;
    for k=1:size(phi,1)
      tmp(k,index(k))=0;
    end
end

fid = fopen('topic-word.txt','wb');
for i=1:size(tw,1)
    for j=1:size(tw,2)
 fprintf(fid,'%s ',words{tw(i,j)});   
    end
    fprintf(fid,'\r');
end

