function [ cOptimal,gammaOptimal,alphaOptimal,beta ] = learnFRRPPForEach( TAll,Feature,indicatorT,e0 )
u = 8000;
iterMax=500;
stepC=0.000001;
stepGamma=0.0002;
stepAlpha=0.0002;
nPost= size(Feature,1);
sizeList=zeros(nPost,1);
indicatorTimeList=cell(nPost,1);
for i=1:nPost
    timeList =  TAll{i};
    tmp = timeList(timeList<=indicatorT);
    sizeList(i)=length(tmp);
    if sizeList(i)<length(timeList)
        timeList(sizeList(i)+1)=(timeList(sizeList(i)+1)+timeList(sizeList(i)))/2;
    else
        timeList(sizeList(i)+1) = timeList(sizeList(i))+0.5;
    end
    indicatorTimeList{i}= timeList;
end

T0=1.1;
%beta = rand(size(Feature,2),1);
C(1,1:nPost)=3;
Gamma(1,1:nPost)=5;
Alpha(1,1:nPost)=1;

for i=1:iterMax
    %% update beta
    [beta,status]=l1_ls(Feature,log(C(i,:))',0.01,0.001,1);
    for p=1:nPost
        T = indicatorTimeList{p};
        alpha = Alpha(i,p);
        gamma = Gamma(i,p);
        c = C(i,p);
        N = sizeList(p);
        %% updating c
        k=1;
        e = 1+ e0 -e0*exp(-1*alpha);
        X=(T(k).^(1-gamma)-T0.^(1-gamma))*(e-exp(-1*alpha*k))/((1-gamma)*(1-exp(-1*alpha)));
        for k=2:N+1
            X=X+(T(k).^(1-gamma)-T(k-1).^(1-gamma))*(e-exp(-1*alpha*k))/((1-gamma)*(1-exp(-1*alpha)));
        end
        dC = -N/c+X+u*(log(c)-Feature(p,:)*beta)/c;
        C(i+1,p)= C(i,p)-dC*stepC;
        if C(i+1,p)<=0
            C(i+1,p) = 0.01;
        end
        c= C(i+1,p);
        %% updating gamma
        k=1;
        dXGamma=(e-exp(-1*alpha*k))*((T0.^(1-gamma)*log(T0)-T(k).^(1-gamma)*log(T(k)))/(1-gamma)+(T(k).^(1-gamma)-T0.^(1-gamma))/((1-gamma).^2))/(1-exp(-1*alpha));
        for k=2:N
            dXGamma = dXGamma +(e-exp(-1*alpha*k))*((T(k-1).^(1-gamma)*log(T(k-1))-T(k).^(1-gamma)*log(T(k)))/(1-gamma)+(T(k).^(1-gamma)-T(k-1).^(1-gamma))/((1-gamma).^2))/(1-exp(-1*alpha));
        end
        dGamma = -1*sum(log(T(1:N)))-c*dXGamma;
        Gamma(i+1,p) = gamma+ stepGamma*dGamma;
        gamma = Gamma(i+1,p) ;
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
        Alpha(i+1,p) = alpha + stepAlpha*dAlpha;
        if (Alpha(i+1,p) <0 || Gamma(i+1,p)<0)
            Alpha(i+1:iterMax+1,p) = Alpha(i,p);
            Gamma(i+1:iterMax+1,p) = Gamma(i,p);
            C(i+1:iterMax+1,p) = C(i,p);
        end
    end
end
cOptimal=C(end,:);
gammaOptimal=Gamma(end,:);
alphaOptimal=Alpha(end,:);
end

