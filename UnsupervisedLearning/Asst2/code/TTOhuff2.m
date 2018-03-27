function [datatwo,pnew,h] = TTOhuff2(data)
%连续两个符号进行哈夫曼编码（基于像素点取值概率）
%data是量化后转换成十进制的行向量的图像数据
datanew = [];
p=[];
databaoliu=data;
while length(find(data~=-1)) >0
    xuhao = find(data~=-1);
    no = data(xuhao(1));
    datanew = [datanew no];
    p = [p length(find(data==no))];
    data(find(data==no))=-1;
end
p=p/length(data);

L=length(datanew);
pnew=[];
datatwo=[];

for i=1:L
    for j=1:L
        s=[datanew(i) datanew(j)]';
        datatwo=[datatwo s];
        pnew=[pnew p(i)*p(j)];
    end
end

pnew = [pnew 0];
q=pnew;
n=length(pnew);
a=zeros(n-1,n); %生成一个n-1 行n 列的数组
for i=1:n-1
[q,l]=sort(q); %对概率数组q 进行从小至大的排序，并且用l 数组返回一个数组，该数组表示概率数组q 排序前的顺序编号
a(i,:)=[l(1:n-i+1),zeros(1,i-1)]; %由数组l 构建一个矩阵，该矩阵表明概率合并时的顺序，用于后面的编码
q=[q(1)+q(2),q(3:n),1]; %将排序后的概率数组q 的前两项，即概率最小的两个数加和，得到新的一组概率序列
end
for i=1:n-1
c(i,1:n*n)=blanks(n*n); %生成一个n-1 行n 列，并且每个元素的的长度为n 的空白数组，c 矩阵用于进行huffman 编码，并且在编码中与a 矩阵有一定的对应关系
end
c(n-1,n)='0'; %由于a 矩阵的第n-1 行的前两个元素为进行huffman 编码加和运算时所得的最
c(n-1,2*n)='1'; %后两个概率，因此其值为0 或1，在编码时设第n-1 行的第一个空白字符为0，第二个空白字符1。
for i=2:n-1
c(n-i,1:n-1)=c(n-i+1,n*(find(a(n-i+1,:)==1))-(n-2):n*(find(a(n-i+1,:)==1))); %矩阵c 的第n-i 的第一个元素的n-1 的字符赋值为对应于a 矩阵中第n-i+1 行中值为1 的位置在c 矩阵中的编码值
c(n-i,n)='0'; %根据之前的规则，在分支的第一个元素最后补0
c(n-i,n+1:2*n-1)=c(n-i,1:n-1); %矩阵c 的第n-i 的第二个元素的n-1 的字符与第n-i 行的第一个元素的前n-1 个符号相同，因为其根节点相同
c(n-i,2*n)='1'; %根据之前的规则，在分支的第一个元素最后补1
for j=1:i-1
    c(n-i,(j+1)*n+1:(j+2)*n)=c(n-i+1,n*(find(a(n-i+1,:)==j+1)-1)+1:n*find(a(n-i+1,:)==j+1));
%矩阵c 中第n-i 行第j+1 列的值等于对应于a 矩阵中第n-i+1 行中值为j+1 的前面一个元素的位置在c 矩阵中的编码值
end
end %完成huffman 码字的分配
for i=1:n
h(i,1:n)=c(1,n*(find(a(1,:)==i)-1)+1:find(a(1,:)==i)*n); %用h 表示最后的huffman 编码，矩阵h的第i 行的元素对应于矩阵c 的第一行的第i 个元素
ll(i)=length(find(abs(h(i,:))~=32)); %计算每一个huffman 编码的长度
end
pnew=pnew(1:end-1);
ll=ll(1:end-1);
disp('二维联合霍夫曼编码平均码长')
l=0.5*sum(pnew.*ll) %计算平均码长
disp('信源熵')
hh=sum(p.*(-log2(p))) %计算信源熵
disp('编码效率')
t=hh/l %计算编码效率
end