function main
%initialize
par=setup;
%solve ode
sim=simulation(par.n,par);
variance=zeros(1,length(sim(1).y));
tx=sim(1).t;
%call function to plot 
setup_up_graph1(par,sim);
title('Lorenz attractor')
xlabel('x');ylabel('y');zlabel('z')
%call function to calculate and plot dispersion
result=setup_graph_2(par,sim,tx,variance);
result=log(result);
title('Dispersion')
xlabel('t');ylabel('variance')
%plot polynomial fit
%p=Polyfit(result,tx);
end
%pass struct to 25 different sets
function sim=simulation(n,par)
for i=1:n
    if i==1
        [t,y]=ode45(@(t,y) F(y,par.rho,par.beta,par.sigma),par.tspan,par.y0);
        sim(i).y=y;
        sim(i).t=t;
    else
        [t,y]=ode45(@(t,y) F(y,par.rho,par.beta,par.sigma),par.tspan,par.y0+par.eps*rand(1));  
        sim(i).y=y;
        sim(i).t=t;
    end
end
end
%ode set
function dydt = F(y,rho,beta,sigma)
dydt=zeros(3,1);
dydt(1)=sigma*(y(2)-y(1));
dydt(2)=rho*y(1)-y(1)*y(3)-y(2);
dydt(3)=y(1)*y(2)-beta*y(3);
end
%parameters
function par=setup
par.n=25;
par.sigma=10;
par.rho=28;
par.beta=8/3;
par.y0=[1 1 1];
par.eps=1e-12;
par.dt=0.01;
par.tmax=100;
par.tspan=0:par.dt:par.tmax;
end
%generate Lorenz plot
function setup_up_graph1(par,sim)
subplot(211)


for j=1:par.n
    x=plot3(sim(j).y(:,1),sim(j).y(:,2),sim(j).y(:,3));
    hold on
end
end
%calculate dispersion and generate plot 2
function result=setup_graph_2(par,sim,tx,variance)
for k=1:length(sim(1).y)
    varx=zeros(1,par.n);
    vary=zeros(1,par.n);
    varz=zeros(1,par.n);
    for kk=1:par.n
        varx(1,kk)=sim(kk).y(k,1);
        vary(1,kk)=sim(kk).y(k,2);
        varz(1,kk)=sim(kk).y(k,2);
        variance(1,k)=sqrt(sum(var(varx)+var(vary)+var(varz)));
    end
end
result=variance;
subplot(212)
plot(tx,variance)
hold on
set(gca, 'YScale', 'log')
end
%polynomial fit of data
function p=Polyfit(par,sim)
clf
t=sim(1:4600);
p=polyfit(t,par(1:4600),1);
t1=linspace(0,46);
y2=polyval(p,t1);
plot(t,par(1:4600))
hold on
plot(t1,y2)
ylabel('variance (log scale)')
xlabel('t')
title('dispersion')
end