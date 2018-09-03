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

% Use with slip_regulation_stage3
% der_TH = [200 100 40 20 0 -1];
% dM_val = [48 32 16 8 -0.5 -2 -8]; %STAGE 3 best

% Use with slip_regulation_stage4
der_TH = [200 100 40 20 15 10 4 1.5 0.8 0.3 0.1 0 -1];
dM_val = [48 32 24 8 6 2 0.5 -0.1 -0.5 -1.25 -2.5 -3 -4 -11]; %STAGE 4


assert(numel(der_TH)+1 == numel(dM_val), "Thershold and values len");

CRITICAL_SLIP_VEL = 20;                 % when v_s is bigger than this, decrease M_h rapidly
CRITICAL_M_CALC_REAL_MISMATCH = 10;     % do not decrease M_h when mismatch is bigger than this
ERR_TOLERABLE = 0.1;            %tolerable error in wanted M and resulting M
Ts = 0.001;                     %recomputing at 1/TS [Hz]
dM_default = 16;

% Setup struct which serves to hold control parameters
par_ctr = struct;
par_ctr.der_TH = der_TH;
par_ctr.dM_val = dM_val;
par_ctr.dM_default = dM_default;
par_ctr.CRITICAL_SLIP_VEL = CRITICAL_SLIP_VEL;  
par_ctr.CRITICAL_M_CALC_REAL_MISMATCH = CRITICAL_M_CALC_REAL_MISMATCH;
par_ctr.ERR_TOLERABLE = ERR_TOLERABLE;
par_ctr.TS = Ts;              %sampling time of refreshing params and recomputing;
par_ctr.r = r;

% Incremental rotary encoders
ppr = 2*pi/1024;                %pulses per revolution

%% DC motor parameters
k = 0.4;            % motor constants
b = 0.1;

L = 0.3;            % armature inductance
R = 3;              % resistnace

%% PWM regulator params
Ua = 300;
Ra = 0.001;
Rb = 0.01; 

%% Initial conditions
v0 = 1;     %initial velocity [m/s]


