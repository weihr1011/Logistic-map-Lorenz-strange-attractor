function main
par=setup;
% first set of initial 1 1 1
yout=[];
rout=[];
%second set of initial -1 -1 1
yout1=[];
rout1=[];
for r=0:0.25:250
    
    options=odeset('Event',@(t,y) find_zeros(t,y,r),'Abstol',1e-8);
    [t,y,te,ye,ie]=ode45(@(t,y) F(t,y,r,par.beta,par.sigma),par.tspan,par.y0,options);
    [t1,y1,te1,ye1,ie1]=ode45(@(t,y) F(t,y,r,par.beta,par.sigma),par.tspan,par.y01,options);
    par.y0=y(end,:);
    par.y01=y1(end,:);
    if isempty(ye)
        continue
    else
        %store value
        rout(1,length(rout)+1:length(rout)+size(ye,1))=r*ones(1,size(ye,1));
        yout(1,length(yout)+1:length(yout)+size(ye,1))=ye(:,1);
        rout1(1,length(rout1)+1:length(rout1)+size(ye1,1))=r*ones(1,size(ye1,1));
        yout1(1,length(yout1)+1:length(yout1)+size(ye1,1))=ye1(:,1);
          
    end
    
end
plot(rout,yout,'k.','MarkerSize',0.1)
hold on
plot(rout1,yout1,'k.','MarkerSize',0.1)
title('Bifurcation diagram of Lorenz system')
xlabel('rho')
ylabel('x')
end
%define event function
function [value,isterminal,direction]=find_zeros(t,y,r)
value=y(3)-r+1;
isterminal=0;
direction=0;
end   
%define ode set
function dydt = F(t,y,rho,beta,sigma)
dydt=zeros(3,1);
dydt(1)=sigma*(y(2)-y(1));
dydt(2)=rho*y(1)-y(1)*y(3)-y(2);
dydt(3)=y(1)*y(2)-beta*y(3);
end
%parameters
function par=setup
par.sigma=10;
par.rho=28;
par.beta=8/3;
par.y0=[1 1 1];
par.y01=[-1 -1 1];
par.eps=1e-2;
par.tspan=[1 10];
end
