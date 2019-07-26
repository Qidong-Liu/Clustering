% by Liu Qidong (Zhengzhou University)
% Global optimal path-based clustering algorithm

clear all;

%input data
mdist=input('name of the data file\n');
data=load(mdist);
x=data(:,1);
y=data(:,2);
[N,w]=size(data);
if w==3
    bel=data(:,3);
    data=data(:,1:2);
end

tic   % Timing starts

%%%GOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
num_clusters=31;
[c,m,d,R]=GOP(data,num_clusters);

%%%AGOP%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%num_clusters=15;
%[c,m,d]=AGOP(data,num_clusters);

toc %Timer end

un=unique(c);
%%%Write to .txt%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%tag=zeros(N,1);
%for i=1:length(un)
%    tag(find(c==un(i)))=i;
%end
%fid=fopen('E:\phd\LZUthesis-master\data\community detection\facebook-gop.txt','w');
%for i=1:N
%    fprintf(fid,'%d\t%d\n',[i,tag(i)]);
%end
%fclose(fid);

%%%%draw picture%%%%%
figure();

for i=1:N
    A(i,1)=0;
    A(i,2)=0;
end
cmap=colormap;

flag=['*','x','d','s','+','^','p','v','>','<','h','o'];
ic2=['r','b','c','m','y','g'];

EE=0;
for i=1:length(un)
    nn=0;
    ic(i)=int8((i*64.)/(length(un)*1.));
    for j=1:N
        if(c(j)==un(i))
           EE=EE+d(j,un(i));
           nn=nn+1;
           A(nn,1)=x(j);
           A(nn,2)=y(j);
        end
    end
    hold on;
    plot(A(1:nn,1),A(1:nn,2),flag(mod(i,12)+1),'MarkerSize',5,'MarkerFaceColor',cmap(ic(i),:),'MarkerEdgeColor',cmap(ic(i),:));
%     plot(A(1:nn,1),A(1:nn,2),flag(mod(i-1,12)+1),'MarkerSize',8,'MarkerEdgeColor',ic2(mod(i-1,6)+1));
end
set(gca,'xtick',[]);
set(gca,'ytick',[]);
set(gca,'LooseInset',get(gca,'TightInset'));
box on;
