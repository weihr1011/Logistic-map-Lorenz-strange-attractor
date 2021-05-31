
function main
par=setup;
for r =0:par.step:4
    xn=par.x_0;
    %transiant state
    for i=1:par.step1
        xnew=r*(xn-xn^2);
        xn = xnew;
    end
    %final state
    for i=1:par.step2
        xnew=r*(xn-xn^2);
        xn=xnew;
        par.r(1,length(par.r)+1)=r;
        par.x(1,length(par.x)+1)=xnew;
    end
end
plot(par.r,par.x,'k.','LineWidth',.1,'Markersize',1.2)
hold on 
title('logistic map')
xlabel('r')
ylabel('x')
end
%parameters
function par=setup
par.x_0=0.5;
par.x=[];
par.r=[];
par.step=0.001;
par.step1=1000;
par.step2=1000;
end


        
        
        
        