function [ error ] = predictForEach( T,refrenceT,indicatorT,cOptimal,gammaOptimal,alphaOptimal,e0)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if T(1)>indicatorT
    T = T*indicatorT/max(T);
end
indicatorTimeList = T(T<=indicatorT);
N=length(indicatorTimeList);
if N<length(T)
    T(N+1)=(T(N+1)+T(N))/2;
else
    T(N+1) = T(N)+1;
end
e = 1+ e0 -e0*exp(-1*alphaOptimal);
Y = e*cOptimal*alphaOptimal*(T(N+1).^(1-gammaOptimal)-refrenceT.^(1-gammaOptimal))/((1-gammaOptimal)*(1-exp(-1*alphaOptimal)));
Y = Y - (N+1)*alphaOptimal-log( e - exp(-1*alphaOptimal*(N+1)));
Nt = (log(1+e.^Y) - Y - log(e)-alphaOptimal)/alphaOptimal;
%%
refrTimeList = T(T<=refrenceT);
trueN=length(refrTimeList);
error = abs((Nt- trueN )/trueN);
end

