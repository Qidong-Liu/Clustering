function [ c,m,d,R ] = GOP( data, k )
%Global optimal path-based clustering algorithm
% by Liu Qidong (Zhengzhou University)
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

m(1)=S(1); mark(m(1))=1;
for i=1:N
    c(i)=m(1);
end

t=2; R(1)=0;
while(t<=k)
    index=0; R(t)=0;
    for i=2:N
        x=S(i);
        if mark(nn(x))==0
            continue;
        end
        r=0;
        for j=1:N
            if d(j,x)<d(j,c(j))
                r=r+d(j,c(j))-d(j,x);
            end
        end
        if r>R(t)
            R(t)=r;
            index=x;
        end
    end
    m(t)=index;
    mark(m(t))=1;
    t=t+1;
    for j=1:N
        if d(j,index)<d(j,c(j))
            c(j)=index;
        end
    end
end

%%%Identify noise
for i=1:N
    for j=1:k
        if c(i)==m(j)
            continue;
        end
        if d(i,c(i))==d(i,m(j))
            c(i)=0;
            break;
        end
    end
end

%%%assign noise

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
    

end

