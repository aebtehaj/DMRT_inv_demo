clear
% This file generates dictionary for inversion of DMRT-QCA for a
% single-layer snowpack based on the inversion algorithm presented in  
% Ebtehaj et al., TGRS, DOI: 10.1109/TGRS.2021.3115663, 2021
% Ardeshir Ebtehaj (September 2021)
clear
addpath '.\DMRT_QMS\common'
addpath '.\DMRT_QMS\passive'
Tsnow = 260;        % snow temperature in K
freq = [10.65 18.70 37 89 166];
obs_angle = [52.8 52.8 52.8 52.8 52.8 49.1];
n = 1;
Tg = 270;           % ground temperature
mv = 0.02;          % soil moisture in bottom soil
clayfrac = 0.3;    
tau = 0.1           % stickiness parameter
rough.model = 'QH'; % soil raoughness parameters
rough.Q = 0;        
rough.H = 0; 
RT = @(x) DMRT_QMS_PM(freq,obs_angle,tau,Tsnow,Tg,mv,clayfrac,n,rough,x);
rho_l =@(d) (25+(d-5)*(200-25)/(100-5))./1000; % lower bound for the density
rho_u =@(d) (75+(d-5)*(400-75)/(100-5))./1000; % upeer boumd for the density
N = 5*10^5;         % number of simulations in the dictionary
updateDisp = DispParfor(N);
Dic = zeros(13,N);
parfor i = 1:N
    d = 5+(100-5)*rand;
    rho = rho_l(d) + (rho_u(d)-rho_l(d))*rand;
    dia = (0.1 +(1-0.1)*rand)./10;
    x = [d rho dia];
    try
    Dic(:,i) = [RT(x);x'];
    catch
    end
    updateDisp()
end
% removing potential erroneous simulations
idx_0 = sum(Dic(1:10,:)<=0)>0;
Dic = Dic(:,~idx_0);
save('Dic_one_layer.mat','Dic','-v7.3');