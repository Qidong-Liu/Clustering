function [ d,mst ] = prim( e )
%Global optimal path-based clustering algorithm
%by Liu Qidong (Zhengzhou University)
N=length(e);
d=zeros(N);
lowcost=zeros(1,N);
adjvex=zeros(1,N);

lowcost=e(1,:);
adjvex=ones(1,N);
p=1; mst=[]; tb=2:N;

for i=1:N-1
    k=lowcost(tb);
    cost_min=min(k);
    index=tb(find(k==cost_min,1));
    
    preindex=adjvex(index);
    maxd=max(d(preindex,p),cost_min);
    d(index,p)=maxd;
    d(p,index)=maxd;
    
    mst=[mst,[preindex;index;cost_min]];
    p=[p,index];
    
    tb(tb==index)=[];
    
    for j=1:length(tb)
        if lowcost(tb(j))>e(tb(j),index)
            lowcost(tb(j))=e(tb(j),index);
            adjvex(tb(j))=index;
        end
    end
end

end

