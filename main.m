%% read file
[numData strData rawData]=xlsread('governmentWeibodata.csv');
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
indicatorTime=10;
e=30; %para
[TBigger,FeatureBigger,indexBigger ] = process( uniqueMid,midAndCommentTime,Feature,indicatorTime,10);
%% RPP
[cVec,gammaVec,alphaVec,errorRPPList,AccRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,0);
ErrorRPP = mean(errorRPPList)
%% ExRPP
[cVec_1,gammaVec_1,alphaVec_1,errorExRPPList,AccExRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,1);
ErrorExRPP = mean(errorExRPPList)
%% FRRPP
[cVec_2,gammaVec_2,alphaVec_2,errorFRRPPList,AccFRRPP] = learnRPP(TBigger,FeatureBigger,refreTime,indicatorTime,e,2);
ErrorFRRPP = mean(errorFRRPPList)

