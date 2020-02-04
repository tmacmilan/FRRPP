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
% %% plot
% subplot(1,2,1)
% plot(LR(:,1),LR(:,2),'.');
% xlabel('Comment Popularity after 20 hours')
% ylabel('Comment Popularity after 24 hours')
% title('linear correlation')
% subplot(1,2,2)
% loglog(LR(:,1),LR(:,2),'.');
% xlabel('Comment Popularity after 20 hours')
% ylabel('Comment Popularity after 24 hours')
% title('logarithmically correlation')
%% LR  prediction
train= log(LR(1:floor(0.6*size(LR,1)),:)+1);
test = log(LR(floor(0.6*size(LR,1))+1:end,:)+1);
p = polyfit(train(:,1),train(:,2),1);
predictList  =  exp(polyval(p,test(:,1)));
test= exp(test);
errorLRList = zeros(size(test,1),1);
for i=1:length(errorLRList)
    errorLRList(i)= abs(predictList(i)-test(i,2))/test(i,2);
end
errorLR = mean(errorLRList);
accNum=0;
for i=1:length(errorLRList)
    if errorLRList(i)<0.1
        accNum=accNum+1;
    end
    AccLR = accNum/length(errorLRList);
end
%% RPP
[cVec,gammaVec,alphaVec,errorRPPList,AccRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,0);
ErrorRPP = mean(errorRPPList)
%% ExRPP
[cVec_1,gammaVec_1,alphaVec_1,errorExRPPList,AccExRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,1);
ErrorExRPP = mean(errorExRPPList)
%% FRRPP
[cVec_2,gammaVec_2,alphaVec_2,errorFRRPPList,AccFRRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,2);
ErrorFRRPP = mean(errorFRRPPList)

