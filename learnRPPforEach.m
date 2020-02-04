function [cOptimal,gammaOptimal,alphaOptimal] = learnRPPforEach(T,indicatorT,e0)
%UNTITLED3 Summary of this function goes here
% Detailed explanation goes here
iterMax=200;
beta1=0.0002;
beta2=0.0002;
C(1)=1;
Gamma(1)=5;
Alpha(1)=1;
indicatorTimeList = T(T<=indicatorT);
N=length(indicatorTimeList);
if N<length(T)
    T(N+1)=(T(N+1)+T(N))/2;
else
    T(N+1) = T(N)+1;
end
T0=1.1;
for i=1:iterMax
    alpha = Alpha(i);c=C(i);gamma=Gamma(i);
    %% updating c
    k=1;
    e = 1+ e0 -e0*exp(-1*alpha);
    X=(T(k).^(1-gamma)-T0.^(1-gamma))*(e-exp(-1*alpha*k))/((1-gamma)*(1-exp(-1*alpha)));
    for k=2:N+1
        X=X+(T(k).^(1-gamma)-T(k-1).^(1-gamma))*(e-exp(-1*alpha*k))/((1-gamma)*(1-exp(-1*alpha)));
    end
    C(i+1)=N/X;
    c=C(i+1);
    %% updating gamma
    k=1;
    dXGamma=(e-exp(-1*alpha*k))*((T0.^(1-gamma)*log(T0)-T(k).^(1-gamma)*log(T(k)))/(1-gamma)+(T(k).^(1-gamma)-T0.^(1-gamma))/((1-gamma).^2))/(1-exp(-1*alpha));
    for k=2:N
        dXGamma = dXGamma +(e-exp(-1*alpha*k))*((T(k-1).^(1-gamma)*log(T(k-1))-T(k).^(1-gamma)*log(T(k)))/(1-gamma)+(T(k).^(1-gamma)-T(k-1).^(1-gamma))/((1-gamma).^2))/(1-exp(-1*alpha));
    end
    dGamma = -1*sum(log(T(1:N)))-c*dXGamma;
    Gamma(i+1) = gamma + beta1*dGamma;
    gamma = Gamma(i+1);
    %% updating alpha
    k=1;
    dXAlpha=(T(k).^(1-gamma)-T0.^(1-gamma))*(k*exp(-1*alpha*k)-(k-1)*exp(-1*alpha*(k+1))-exp(-1*alpha))/((1-gamma)*((1-exp(-1*alpha)).^2));
    for k=2:N
        dXAlpha=dXAlpha+(T(k).^(1-gamma)-T(k-1).^(1-gamma))*(k*exp(-1*alpha*k)-(k-1)*exp(-1*alpha*(k+1))-exp(-1*alpha))/((1-gamma)*((1-exp(-1*alpha)).^2));
    end
    
    dAlpha = -1*N*exp(-1*alpha)/(1-exp(-1*alpha))-c*dXAlpha;
    for k=1:N
        dAlpha = dAlpha +(e0*exp(-1*alpha)+k*exp(-1*alpha*k))/(e-exp(-1*alpha*k));
    end
    Alpha(i+1) = alpha + beta2*dAlpha;
    alpha= Alpha(i+1);
    if (alpha <0 || gamma<0)
        Alpha(i+1) = Alpha(i);
        Gamma(i+1) = Gamma(i);
        break;
    end
end
cOptimal=c;
gammaOptimal=gamma;
alphaOptimal=alpha;


end

