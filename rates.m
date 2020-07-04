% Epidemic model based on SIR method 
clear all; clc; close all
T=365; % time length of simulation, days
N=1000000; % total population
ncontact=1.8; %no of persons each infected person comes in contact with in a day
x0=10; % initial infected number
rinf=.1; % probability that an infected person can infect a susceptible person he/she comes in contact with
rcurehome=0.8; % fraction of those infected who get cured at home (rest need hospitalization)
rdeath=0.25; %fraction of those hospitalized who die
quarantined=0.4; % fraction of population in social distancing
illtime=14; %days to get cured at home from getting infection
hosptime=illtime; % days from getting infected to get hospitalized if not cured
deathtime=14; % days to die or getting discharged after getting hospitalized

t=1;
x(t)=x0; xcurr(t)=x0; xnew(t)=0; xsus(t)=N-x0;
xcuredhome(t)=0; xnewcuredhome(t)=0;
xcured(t)=0; xnewcured(t)=0;
xhosp(t)=0; xnewhosp(t)=0; xcurrhosp(t)=0; 
xdead(t)=0; xnewdead(t)=0;
xdischarged(t)=0;xnewdischarged(t)=0;

time(t)=t;
for t=2:T
    if(t<=illtime)
        xnewcuredhome(t)=xnewcuredhome(t-1);
        xnewhosp(t)=xnewhosp(t-1);
    else
        xnewcuredhome(t)=rcurehome*xnew(t-illtime);% cured at home on day t
        xnewhosp(t)=(1-rcurehome)*xnew(t-illtime); % sent to hospital on day t
    end
    
    if(t<=hosptime+deathtime)
        xnewdead(t)=xnewdead(t-1);
        xnewdischarged(t)=xnewdischarged(t-1);
    else
        xnewdead(t)=rdeath*xnewhosp(t-deathtime); % died on day t
        xnewdischarged(t)=(1-rdeath)*xnewhosp(t-deathtime); %discharnged on day t        
    end
    
     xcuredhome(t)=xcuredhome(t-1)+xnewcuredhome(t);
     xhosp(t)=xhosp(t-1)+xnewhosp(t);
     xdischarged(t)=xdischarged(t-1)+xnewdischarged(t);
     xdead(t)=xdead(t-1)+xnewdead(t);
     xcurrhosp(t)=xhosp(t)-xdischarged(t)-xdead(t);
     
     xcured(t)= xcuredhome(t)+xdischarged(t); % total cured on day t
    
    xnew(t)=rinf*xcurr(t-1)*(1-quarantined)*ncontact*(xsus(t-1)/N); % newly infected on day t
    x(t)=x(t-1)+xnew(t); % total infected
    xsus(t)=N-x(t); % susceptible on day t
    xcurr(t)=x(t)-xcured(t)-xdead(t); % currently infected on day t
    time(t)=t;
end

plot(time,x/N)
hold on
plot(time,xcurr/N)
hold on
plot(time, xnew/N)
hold on
plot(time,xcurrhosp/N)
hold on
plot(time, xcured/N)
hold on
plot(time,xdead/N)
legend('total infected','currenty infected','new infected','currently hospitalized','total cured','total dead')
xlabel('time (days)'); ylabel('fraction of population')
axis([0,T,-.2 1.2])