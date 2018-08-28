 close all; clc;

%% Wheel characteristics
m = 100;    %longitudinal inertia weight [kg]
N = 500;    %normal reaction [N]
Is = 0.2;   %moment of inertia [kg*m^2]
r = 0.2;    %radius of the wheel [m]
n = 5;      %transmission ratio [-]

%% Aerodynamic resistance
B0 = 2.5; %transverse [kg/m]

%% Magic Formula Constants
MFC1 = [9.5 1.9 1.14  0.75];    %constants for dry asphalt
MFC2 = [2.5 1.8 1 0.2];         %constants for wet asphalt
MFC3 = [1.5 1.8 0.4 0.2];       %constants for icy surface

s= 0:0.01:1; %longitudal slip 
T1= N* MFC1(3)*sin(MFC1(2)*atan(MFC1(1)*s-MFC1(4)*(MFC1(1)*s-atan(MFC1(1)*s))));
T2= N* MFC2(3)*sin(MFC2(2)*atan(MFC2(1)*s-MFC2(4)*(MFC2(1)*s-atan(MFC2(1)*s))));
T3= N* MFC3(3)*sin(MFC3(2)*atan(MFC3(1)*s-MFC3(4)*(MFC3(1)*s-atan(MFC3(1)*s))));

%% Slip regulator tuning parameters
% der_TH = [50 20 8 4 2 1 0.8 0.6 0.2 0 -1];
% dM_val = [128 128 128 64 32 16 -2 -4 -8 -16 -32 0];

% der_TH = [1000 500 200 40 20 10 5 2 1 -1 -2 ];
% dM_val = [128 64 32 16 8 4 0.1 -0.1 -1 -2 -4 -8]; %Ts 0.005 dry quite OK, trans bad

der_TH = [1000 500 200 40 20 10 5 2 1 -1 -2 ];
dM_val = [128 64 32 16 8 4 1 0.1 -1 -2 -4 -8]; %

assert(numel(der_TH)+1 == numel(dM_val), "Thershold and values len");

CRITICAL_SLIP_VEL = 10;
ERR_TOLERABLE = 0.1;            %tolerable error in wanted M and resulting M
Ts = 0.005;                     %recomputing at 1000Hz

par_ctr = struct;
par_ctr.der_TH = der_TH;
par_ctr.dM_val = dM_val;
par_ctr.CRITICAL_SLIP_VEL = CRITICAL_SLIP_VEL;
par_ctr.ERR_TOLERABLE = ERR_TOLERABLE;
par_ctr.TS = Ts;              %sampling time of refreshing params and recomputing;
par_ctr.r = r;

% Incremental rotary encoders
ppr = 2*pi/1024;                %pulses per revolution

%% DC motor parameters
 %motor constants
k = 20;     % ?
B = 10;     % multiplies dFi (back-emf)

L = 0;
R = 0;

%% PWM regulator params
Ua = 300;
Ra = 0.001;
Rb = 0.01; 

%% Initial conditions
v0 = 1;     %initial velocity [m/s]


