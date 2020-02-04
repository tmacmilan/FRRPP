function [ TBigger,FeatureBigger,indexBigger] = process( uniqueMid,midAndCommentTime,Feature,indicatorT,number )
%ɸѡ������һ�������ۻ�ת����΢��
N = length(uniqueMid);
indexBigger=[];
TBigger={};FeatureBigger=[];
iBigger=0;
for i=1:N
    %display(i);
    mid = uniqueMid(i);
    index = strcmp(midAndCommentTime(:,1),mid);
    timeList = cell2mat(midAndCommentTime(index,2));
    timeList = sort(timeList);
    if length(timeList)>number && timeList(1)<indicatorT-1
        indexBigger=[indexBigger;i];
        iBigger=iBigger+1;
        TBigger{iBigger}= timeList;
        FeatureBigger(iBigger,:)=Feature(i,:);
    end
end
end

