function [ error ] = predictRPP_PL_ForEach( T,refrenceT,indicatorT,cOptimal,gammaOptimal,e)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
indicatorTimeList = T(T<=indicatorT);
N=length(indicatorTimeList);
if N<length(T)
    T(N+1)=(T(N+1)+T(N))/2;
else
    T(N+1) = T(N)+1;
end    
F = exp(cOptimal*(refrenceT.^(1-gammaOptimal)/(1-gammaOptimal)-T(N).^(1-gammaOptimal)/(1-gammaOptimal)));
Nt = (e+N)*F-e;
refrTimeList = T(T<=refrenceT);
trueN=length(refrTimeList);
error = abs((Nt- trueN )/trueN);
end

