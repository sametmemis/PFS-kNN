%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Citation:
% S. Memiş, 2023. Picture Fuzzy Soft Matrices and Application of Their 
% Distance Measures to Supervised Learning: Picture Fuzzy Soft k-Nearest 
% Neighbor (PFS-kNN), Electronics 2023, 12(19), 4129.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Abbreviation of Journal Title: Electronics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://doi.org/10.3390/electronics12194129
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% https://www.researchgate.net/profile/Samet_Memis2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Demo: 
% clc;
% clear all;
% DM = importdata('Wine.mat');
% [x,y]=size(DM);
% 
% data=DM(:,1:end-1);
% class=DM(:,end);
% if prod(class)==0
%     class=class+1;
% end
% k_fold=5;
% cv = cvpartition(class,'KFold',k_fold);
%     for i=1:k_fold
%         test=data(cv.test(i),:);
%         train=data(~cv.test(i),:);
%         T=class(cv.test(i),:);
%         C=class(~cv.test(i),:);
%     
%         sPFSkNN=PFSkNN(train,C,test,3,0.5,5);
%         accuracy(i,:)=sum(sPFSkNN==T)/numel(T);
%     end
% mean_accuracy=mean(accuracy);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PredictedClass=PFSkNN(train,C,test,k,L,p)
[em,en]=size(train);
[tm,n]=size(test);
% L1=round(sqrt(mean(std(train(:,1:end-1)))));
% L1=round(sqrt(mean([mean(mean(train(:,1:end-1))),mean(min(train(:,1:end-1))),mean(max(train(:,1:end-1)))])))
data=[train;test];
for j=1:n
    data(:,j,1)=(1-(1-normalise(data(:,j))).^L);
    data(:,j,2)=(normalise(data(:,j)))./L;
    data(:,j,3)=(1-normalise(data(:,j))).^(L*(L+1));
end

clear train test;
train(:,:,:)=data(1:em,:,:);
test(:,:,:)=data(em+1:end,:,:);

for i=1:tm
    a(:,:,1)=test(i,:,1);
    a(:,:,2)=test(i,:,2);
    a(:,:,3)=test(i,:,3);
    for j=1:em
        b(:,:,1)=train(j,:,1);
        b(:,:,2)=train(j,:,2);
        b(:,:,3)=train(j,:,3);

        Dm(j,1)=pfsMd(a,b,p);
    end
    [~,NN]= sort(Dm);
    PredictedClass(i,1)=C(mode(NN(1:k)));
end
end

function na=normalise(a)
[m,n]=size(a);
    if max(a)~=min(a)
        na=(a-min(a))/(max(a)-min(a));
    else
        na=ones(m,n);
    end
end                                                                                                                                                                  

% Minkowski metric over pfs-matrices
function X=pfsMd(a,b,p)
if size(a)~=size(b)
else
[m,n,~]=size(a);
d=0;
  for i=1:m
    for j=1:n
       d=d+abs(a(i,j,1)-b(i,j,1))^p+abs(a(i,j,2)-b(i,j,2))^p+abs(a(i,j,3)-b(i,j,3))^p+abs((1-a(i,j,1)-a(i,j,3))-(1-b(i,j,1)-b(i,j,3)))^p;
    end
  end
  X=(d/3)^(1/p);
end
end
