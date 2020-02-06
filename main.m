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
[cVec,gammaVec,alphaVec] = learnFRRPPForEach(TBigger,FeatureBigger,indicatorTime,e); %%
errorFRRPPList =zeros(length(indexBigger),1)
for i=1:length(indexBigger)
     errorFRRPPList(i)= predictForEach(TBigger,refreTime,indicatorTime,cVec(i),gammaVec(i),alphaVec(i),e);
end
ErrorFRRPP = mean(errorFRRPPList(errorFRRPPList<1));
Acc= sum(errorFRRPPList<0.1)/N;

