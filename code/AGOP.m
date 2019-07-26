function [ c,M,d ] = AGOP( data, k )
%AGOP
[N,~]=size(data);
e=pdist(data);
e=squareform(e);

[d,mst]=prim(e);
degree=sum(d);
[~,S]=sort(degree);

for i=1:N
    nn(S(i))=S(1);
    mind=d(S(i),S(1));
    for j=2:i-1
        if d(S(i),S(j))<mind
            mind=d(S(i),S(j));
            nn(S(i))=S(j);
        end
    end
end

mark=zeros(N,1);
flag=zeros(k,1);

M=S(1:k);
mark(M)=1;

for i=1:N
    temp=d(i,M);
    mind=min(temp);
    [~,kb]=find(d(i,M)==mind,1);
    c(i)=kb;
end

for i=k+1:N
    x=S(i);
    if mark(nn(x))~=1
        continue;
    end
    cost=0; mark(x)=1; M(k+1)=x;
    G(1:k)=0;
    for j=1:N
        if d(j,x)<d(j,M(c(j)))
            cost=cost+d(j,M(c(j)))-d(j,x);
            c(j)=k+1;
        else
            G(c(j))=G(c(j))+d(j,nn(M(c(j))))-d(j,M(c(j)));
        end
    end
    G(1)=realmax;
    minG=min(G);
    index=find(G==minG,1);
    if cost>minG
        mark(M(index))=0;
        dm=M(index);
        index1=index;
        M(index)=x;
    else
        mark(x)=0;
        dm=x;
        index1=k+1;
    end
    mind=realmax;
    for j=1:k
        if M(j)==dm
            continue;
        end
        if d(dm,M(j))<mind
            mind=d(dm,M(j));
            index2=j;
        end
    end
    for j=1:N
        if c(j)==index1
            c(j)=index2;
        end
        if c(j)==k+1
            c(j)=index;
        end
    end
    flag(1:k)=0;
    for j=1:N
        x=S(j);
        if flag(c(x))==0
            mark(M(c(x)))=0;
            flag(c(x))=1;
            M(c(x))=x;
            mark(M(c(x)))=1;
        end
    end
end

%%%识别噪声点

for i=1:N
    for j=1:k
        if c(i)==j
            continue;
        end
        if d(i,M(c(i)))==d(i,M(j))
            c(i)=0;
            break;
        end
    end
end

%%%分配噪声点

row1=find(c(mst(1,:))==0);
row2=find(c(mst(2,:))==0);
row=union(row1,row2);
pr=mst(:,row);
op=sortrows(pr',3);
[lp,~]=size(op);
tag=0;
for i=1:lp
    term=op(i,:);
    if c(term(1))==0 && c(term(2))==0
        tag=tag+1;
        c(term(1))=-tag;
        c(term(2))=-tag;
    elseif c(term(1))==0 && c(term(2))~=0
        c(term(1))=c(term(2));
    elseif c(term(1))~=0 && c(term(2))==0
        c(term(2))=c(term(1));
    elseif c(term(1))<0 && c(term(2))>0
        tt=find(c==c(term(1)));
        c(tt)=c(term(2));
    elseif c(term(1))>0 && c(term(2))<0
        tt=find(c==c(term(2)));
        c(tt)=c(term(1));
    elseif c(term(1))<0 && c(term(2))<0
        tt=find(c==c(term(2)));
        c(tt)=c(term(1));
    end
   
end