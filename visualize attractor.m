clear
par=setup;
ii=1;
sim=simulation(par.n,par);
for j=1:par.n
    a=sim(j).y;
    xx(j)=plot3(a(1,1),a(1,2),a(1,3));
    hold on
end
title('Lorenz attractor')
xlabel('x')
ylabel('y')
zlabel('z')
while ii<size(a,1)
    dis=zeros(3,par.n);
    for j=1:par.n
        b=sim(j).y;
        xx(j).XData=b(1:ii,1);
        xx(j).YData=b(1:ii,2);
        xx(j).ZData=b(1:ii,3);
        dis(1,j)=b(ii,1);
        dis(2,j)=b(ii,2);
        dis(3,j)=b(ii,3);
        hold on
        view(ii*par.dt*30,30)
        drawnow
    end
    ii=ii+1;
end
function sim=simulation(n,par)
for i=1:n
    if i==1
        [t,y]=ode45(@(t,y) F(y,par.rho,par.beta,par.sigma),par.tspan,par.y0);
        sim(i).y=y;
    else
        [t,y]=ode45(@(t,y) F(y,par.rho,par.beta,par.sigma),par.tspan,par.y0+par.eps*rand(1));  
        sim(i).y=y;
    end
end
end

function dydt = F(y,rho,beta,sigma)
dydt=zeros(3,1);
dydt(1)=sigma*(y(2)-y(1));
dydt(2)=rho*y(1)-y(1)*y(3)-y(2);
dydt(3)=y(1)*y(2)-beta*y(3);
end
function par=setup
par.n=2;
par.sigma=10;
par.rho=28;
par.beta=8/3;
par.y0=[3 3 3];
par.eps=1e-2;
par.dt=0.01;
par.tmax=20;
par.tspan=0:par.dt:par.tmax;
end
function getvideo(par)%generate mp4 video
myWriter=VideoWriter('Lorenztest1','MPEG-4');
myWriter.FrameRate=20;
open(myWriter);
writeVideo(myWriter,par);
close(myWriter)
end


