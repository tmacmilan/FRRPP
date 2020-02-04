function [cVec,gammaVec,alphaVec,error,Acc] = learnRPP(TALL,Feature,refrenceT,indicatorT,e,method)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
N = size(Feature,1);
cVec =zeros(N,1);
gammaVec =zeros(N,1);
alphaVec =zeros(N,1);
tStart=0.01;%constant To avoid this, we manually add a constant value tto all tm
error=size(N,1);
accNum = 0;
ii=1;
for i=1:N
    timeList = TALL{i};
    timeList = timeList+tStart;
    if method ==0 %% RPP
        [cVec(i),gammaVec(i)] = learnRPP_PL_forEach(timeList,indicatorT,e);
        error(i) = predictRPP_PL_ForEach(timeList,refrenceT,indicatorT,cVec(i),gammaVec(i),e);
    else if method==1 %% ExRpp
            [cVec(i),gammaVec(i),alphaVec(i)] = learnRPPforEach(timeList,indicatorT,e);
            error(i) = predictForEach(timeList,refrenceT,indicatorT,cVec(i),gammaVec(i),alphaVec(i),e);
        end
    end
end
if method==2
    [cVec,gammaVec,alphaVec] = learnFRRPPForEach(TALL,Feature,indicatorT,e); %%
    for i=1:N
        error(i)= predictForEach(TALL{i},refrenceT,indicatorT,cVec(i),gammaVec(i),alphaVec(i),e);
    end
end

meanError = mean(error(error<1));
for i=1:N
    if error(i)>1 || isnan(error(i))
        ii=ii+1;
        error(i) = meanError;%“Ï≥£
        accNum = accNum -1;
    end
    if error(i)<0.1
        accNum=accNum+1;
    end
    Acc = accNum/N;
end
display(ii);
end

