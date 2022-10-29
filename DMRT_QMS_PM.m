function Tb = DMRT_QMS_PM(freq,obs_angle,tau,Tsnow,Tg,mv,clayfrac,n,rough,x)
% Multifrequency implementation of DMRT_QMS
% freq:  vector of frequencies
% Tg  :  ground tempertaure
% n   :  number of layers
% x   : the input parameters of the model for an n-layer snowpack
%     x(1),...,x(n)    : thickness of the layers
%     x(n+1),...,x(2n) : density of the layers 
%     x(2n+1),...,x(3n): grain size of the layers
%     x(3n+1),...,x(4n): snow-cover temperture
depth = x(1:n);
rho = x(n+1:2*n);
dia = x(2*n+1:3*n);
Tb = [];
tau = tau*ones(1,n);
for i = 1:length(freq)
    % Input parameters:
    %   fGHz - frequncy in GHz, vector
    %   dia  - snow grain diameter, 1D array
    %   rho  - snow density in gm/cc, 1D array
    %   tau  - stickiness parameter in QCA model, 1D array
    %   depth - snow depth of each layer in centimeter, 1D array, from top to bottom
    %   Tsnow - snow temperature in Kelvin, 1D array
    %   Tg    - ground temperature in Kelvin, scalar
    %   epsr_ground -ground permittivity, could be complex
    %   rough - specify the roughness
    %           'QH' model: Q, H
    %           'WM' (Wegmuller and Matzler 1999): s (rms height)
    %
    % Output:
    %   TBv, TBh - array of Brightness Temperature in vertical and horizontal
    %       polrization
    %   deg0  - sampling angles of TB in air, in degree.
    %   ot,albedo,epsr_snow: optical thickness, scattering albedo and snow
    %       effective permittivity of each layer
    %
    % Ref:  Liang et al., TGRS, 46(11): 3663-3671, 2008
    % Copyright: University of Washington, Electrical Engineering Department
    % Revision Date: Aug. 1, 2014, Sep. 09, 2014.
    % DMRT_QMS_passive(fGHz,dia,rho,tau,depth,Tsnow,Tg,epsr_ground,rough)
    epsr_ground = soil_perm_MBSDM_Mironov(mv,clayfrac,freq(i));
    [TBv,TBh,deg0,ot,albedo,epsr_snow] = DMRT_QMS_passive(freq(i),dia,rho,tau,depth,Tsnow,Tg,epsr_ground,rough);
    Tb_v = spline(deg0,TBv,obs_angle(i));
    %Tb_v = interp1(deg0,TBv,obs_angle(i),'pchip');
    Tb_h = spline(deg0,TBh,obs_angle(i));
    %Tb_h = interp1(deg0,TBh,obs_angle(i),'pchip');
    Tb = [Tb;Tb_v;Tb_h];
end