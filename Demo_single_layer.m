% This is a demo code for the following paper
% Ebtehaj et al., TGRS, DOI: 10.1109/TGRS.2021.3115663, 2021
% The forwad DMRT-QMS codes are from 
% Liang et al., TGRS, 46(11): 3663-3671, 2008
% Ardeshir Ebtehaj (September 2021)
clear
addpath '.\DMRT_QMS\common'
addpath '.\DMRT_QMS\passive'
Tsnow = 260;         % snow temperature [K]
n_c = 10;            % number of channels
p = 0.5;
sig_obs = 0;         % observation noise [K]
tau = 0.1;
freq = [10.65 18.70 37 89 166];
freq = freq(1:n_c/2);
obs_angle = [52.8 52.8 52.8 52.8 49.1];
obs_angle = obs_angle(1:n_c/2);                   
Tg = 270;            % ground temperature [K]
mv = 0.02;           % soil msoiture [-]
clayfrac = 0.3;
% soil roughness model
rough.model = 'QH';
rough.Q = 0;          
rough.H = 0;
% lower and upper bound of the density values [g/cm3]
rho_l =@(d) (25+(d-5)*(200-25)/(100-5))./1000; 
rho_u =@(d) (75+(d-5)*(400-75)/(100-5))./1000;
RT = @(x) DMRT_QMS_PM(freq,obs_angle,tau,Tsnow,Tg,mv,clayfrac,1,rough,x);
options = optimoptions(@lsqnonlin,'Algorithm','trust-region-reflective','display','off','UseParallel',false);
% Loading the dictionary
load Dic_one_layer.mat
% number of retrieval experiments
N = 25;             
updateDisp = DispParfor(N);
parfor i=1:N
    depth = 5 +(100-5)*rand;
    rho   = rho_l(depth)+(rho_u(depth)- rho_l(depth))*rand;
    dia = (0.1+(1-0.1)*rand)./10;
    x = [depth rho dia];
    X(i,:) = x;
    Tb_obs = RT(x)+normrnd(0,sig_obs,n_c,1);
    Idx = knnsearch(Dic(1:n_c,:)',Tb_obs','k',20,'Distance','minkowski','p',p);
    Dic_sub = Dic(:,Idx);
    x0 = mean(Dic_sub(11:end,:),2);
    lb = min(Dic_sub(11:end,:),[],2)';
    ub = max(Dic_sub(11:end,:),[],2)';
    fun = @(x) RT(x) - Tb_obs;
    try
    X_hat(i,:) = lsqnonlin(fun,x0,lb,ub,options);
    catch
    end
    updateDisp();
end
cmap_1 = [125 0 0]./255;
cmap_2 = [0 125 0]./255;
cmap_3 = [0 0 125]./255;
tiledlayout(1,3,'TileSpacing','compact')

nexttile
scatter(X(:,1),X_hat(:,1),'MarkerFaceColor',cmap_1,'MarkerEdgeColor',cmap_1,'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5,'SizeData',25);
xlabel('$d \,\, {\rm [cm]}$','interpreter','latex','fontsize',16)
ylabel('$\hat{d}$','interpreter','latex','fontsize',16)
set(gca,'TickDir','out','FontName','Times','fontsize',14); box on; axis square; grid on
xlim([0 100]); ylim([0 100])

nexttile
scatter(X(:,2),X_hat(:,2),'MarkerFaceColor',cmap_2','MarkerEdgeColor',cmap_2,'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5,'SizeData',25);
xlabel('$\rho \,\, {\rm [g.cm^{-3}]}$','interpreter','latex','fontsize',16)
ylabel('$\hat{\rho}$','interpreter','latex','fontsize',16)
set(gca,'TickDir','out','FontName','Times','fontsize',14); box on; axis square; grid on; xlim([0.15 0.5]); ylim([0.15 0.5]);
set(gca,'ytick',[0.2 0.3 0.4 0.5])  % use whatever you want
xlim([0.05 0.4]); ylim([0.05 0.40]);

nexttile
scatter(X(:,3),X_hat(:,3),'MarkerFaceColor',cmap_3,'MarkerEdgeColor',cmap_3,'MarkerFaceAlpha',.5,'MarkerEdgeAlpha',.5,'SizeData',25);
xlabel('$\delta \,\, {\rm [cm]}$','interpreter','latex','fontsize',16)
ylabel('$\hat{\delta}$','interpreter','latex','fontsize',16)
set(gca,'TickDir','out','FontName','Times','fontsize',14); box on; axis square; grid on
xlim([0.1 1]./10); ylim([0.1 1]./10);

disp(['bias = ', num2str(mean(X-X_hat))])
disp(['rmse = ', num2str(sqrt(sum(X-X_hat).^2/N))])