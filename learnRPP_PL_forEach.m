function [cOptimal,gammaOptimal] = learnRPP_PL_forEach(T,indicatorT,e)
%power low
iterMax=300;
beta1=0.0002;
c(1)=1;
gamma(1)=5;
indicatorTimeList = T(T<=indicatorT);
N=length(indicatorTimeList);
if N<length(T)
    T(N+1)=(T(N+1)+T(N))/2;
else
    T(N+1) = T(N)+1;
end
for i=1:iterMax
    X=0;
    for k=1:N
        X=X+T(k).^(1-gamma(i))/(1-gamma(i));
    end
    X=(N+e)*(T(N+1).^(1-gamma(i)))/(1-gamma(i))-X;
    %% updating c
    c(i+1)=N/X;
    if c(i+1)<0
        c(i+1)=c(i);
        break;
    end
    %% updating gamma
    dXGamma=0;
    for k=1:N
        dXGamma = dXGamma +T(k).^(1-gamma(i))*((1-gamma(i))*log(T(k))-1)/(1-gamma(i)).^2;
    end
    dXGamma = dXGamma+(N+e)*T(N+1).^(1-gamma(i))*(1-(1-gamma(i))*log(T(N+1)))/((1-gamma(i)).^2);
    dGamma = -1*sum(log(T(1:N)))-c(i+1)*dXGamma;
    gamma(i+1) = gamma(i) + beta1*dGamma;
    if gamma(i+1)<0
        gamma(i+1)=gamma(i);
        break;
    end
    
end
cOptimal=c(end);
gammaOptimal=gamma(end);

end

