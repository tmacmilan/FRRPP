function [cOptimal,gammaOptimal,alphaOptimal] = learnRPPforEach(T,indicatorT,e0)
%UNTITLED3 Summary of this function goes here
% Detailed explanation goes here
iterMax=300;
beta1=0.0002;
beta2=0.0002;
c(1)=3;
gamma(1)=5;
alpha(1)=1;
indicatorTimeList = T(T<=indicatorT);
N=length(indicatorTimeList);
if N<length(T)
    T(N+1)=(T(N+1)+T(N))/2;
else
    T(N+1) = T(N)+1;
end
T0=1.1;
for i=1:iterMax
    %% updating c
    k=1;
    e = 1+ e0 -e0*exp(-1*alpha(end));
    X=(T(k).^(1-gamma(end))-T0.^(1-gamma(end)))*(e-exp(-1*alpha(end)*k))/((1-gamma(end))*(1-exp(-1*alpha(end))));
    for k=2:N+1
        X=X+(T(k).^(1-gamma(end))-T(k-1).^(1-gamma(end)))*(e-exp(-1*alpha(end)*k))/((1-gamma(end))*(1-exp(-1*alpha(end))));
    end
    c(i+1)=N/X;
    %% updating gamma
    k=1;
    dXGamma=(e-exp(-1*alpha(end)*k))*((T0.^(1-gamma(i))*log(T0)-T(k).^(1-gamma(i))*log(T(k)))/(1-gamma(i))+(T(k).^(1-gamma(i))-T0.^(1-gamma(i)))/((1-gamma(i)).^2))/(1-exp(-1*alpha(end)));
    for k=2:N
        dXGamma = dXGamma +(e-exp(-1*alpha(end)*k))*((T(k-1).^(1-gamma(i))*log(T(k-1))-T(k).^(1-gamma(i))*log(T(k)))/(1-gamma(i))+(T(k).^(1-gamma(i))-T(k-1).^(1-gamma(i)))/((1-gamma(i)).^2))/(1-exp(-1*alpha(end)));
    end
    dGamma = -1*sum(log(T(1:N)))-c(end)*dXGamma;
    gamma(i+1) = gamma(i) + beta1*dGamma;
    
    %% updating alpha
    k=1;
    dXAlpha=(T(k).^(1-gamma(end))-T0.^(1-gamma(end)))*(k*exp(-1*alpha(i)*k)-(k-1)*exp(-1*alpha(i)*(k+1))-exp(-1*alpha(i)))/((1-gamma(end))*((1-exp(-1*alpha(i))).^2));
    for k=2:N
        dXAlpha=dXAlpha+(T(k).^(1-gamma(end))-T(k-1).^(1-gamma(end)))*(k*exp(-1*alpha(i)*k)-(k-1)*exp(-1*alpha(i)*(k+1))-exp(-1*alpha(i)))/((1-gamma(end))*((1-exp(-1*alpha(i))).^2));
    end
    
    dAlpha = -1*N*exp(-1*alpha(i))/(1-exp(-1*alpha(i)))-c(i+1)*dXAlpha;
    for k=1:N
        dAlpha = dAlpha +(e0*exp(-1*alpha(i))+k*exp(-1*alpha(i)*k))/(e-exp(-1*alpha(i)*k));
    end
    alpha(i+1) = alpha(i) + beta2*dAlpha;
    if (alpha(i+1) <0 || gamma(i+1)<0)
        alpha(i+1) = alpha(i);
        gamma(i+1) = gamma(i);
        break;
    end
end
cOptimal=c(end);
gammaOptimal=gamma(end);
alphaOptimal=alpha(end);


end

