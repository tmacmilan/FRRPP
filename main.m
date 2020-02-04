%% read file
[numData strData rawData]=xlsread('governmentSinaWeibo.csv');

%%
Header = rawData(1,:);
OriginalData =  rawData(2:end,:);
midList = OriginalData(:,1);
uniqueMid = unique(midList);
midAndCommentTime = rawData(2:end,[1,2]);
N = length(uniqueMid);
Feature = zeros(N,16);

%% Process
for i=1:N
    mid = uniqueMid(i);
    index = strcmp(midAndCommentTime(:,1),mid);
    id= find(index==1);
    Feature(i,:)=  cell2mat(OriginalData(id(1),10:25));
end

%% Settting
refreTime=24;
indicatorTime=20;
e=30; %para
[TBigger,FeatureBigger,indexBigger ] = process( uniqueMid,midAndCommentTime,Feature,indicatorTime,10);
%% LR
LR = zeros(size(indexBigger,1),2);
for i=1:size(indexBigger,1)
    %%
    timeList = TBigger{i};
    LR(i,1)= sum(timeList<indicatorTime);
    LR(i,2)= sum(timeList<refreTime);
end
%% plot
LR=LR(LR(:,2)<100,:);
subplot(1,2,1)
plot(LR(:,1),LR(:,2),'.');
xlabel('Comment Popularity after 20 hours')
ylabel('Comment Popularity after 24 hours')
title('linear correlation')
subplot(1,2,2)
loglog(LR(:,1),LR(:,2),'.');
xlabel('Comment Popularity after 20 hours')
ylabel('Comment Popularity after 24 hours')
title('logarithmically correlation')
%% LR  prediction
train= log(LR(1:floor(0.6*size(LR,1)),:)+1);
test = log(LR(floor(0.6*size(LR,1))+1:end,:)+1);
p = polyfit(train(:,1),train(:,2),1);
predictList  =  exp(polyval(p,test(:,1)));
test= exp(test);
errorLRList= abs(predictList-test(:,2))./test(:,2);
errorLR = mean(errorLRList);
AccLR = sum(errorLRList<0.1)/length(errorLRList);
%% ML
K=6;
ML = zeros(size(indexBigger,1),K+1);
for i=1:size(indexBigger,1)
    %%
    timeList = TBigger{i};
    for j=1:K
     ML(i,j)= sum(timeList<indicatorTime*j/K);   
    end
    ML(i,7)= sum(timeList<refreTime);
end
train= log(ML(1:floor(0.6*size(ML,1)),:)+1);
test = log(ML(floor(0.6*size(ML,1))+1:end,:)+1);
[b]= regress(train(:,K+1),train(:,1:K));
predictList  = exp(test(:,1:K)*b);
test= exp(test);
errorMLList= abs(predictList-test(:,K+1))./test(:,K+1);
errorML = mean(errorMLList);
AccML = sum(errorMLList<0.1)/length(errorMLList);
%% RPP
[cVec,gammaVec,alphaVec,errorRPPList,AccRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,0);
ErrorRPP = mean(errorRPPList)
%% ExRPP
[cVec_1,gammaVec_1,alphaVec_1,errorExRPPList,AccExRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,1);
ErrorExRPP = mean(errorExRPPList)
%% FRRPP
[cVec_2,gammaVec_2,alphaVec_2,errorFRRPPList,AccFRRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,2);
ErrorFRRPP = mean(errorFRRPPList)

