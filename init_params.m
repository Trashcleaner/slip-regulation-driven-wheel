 close all; clc;

% Wheel characteristics
m = 100;    %longitudinal inertia weight [kg]
N = 500;    %normal reaction [N]
Is = 0.2;   %moment of inertia [kg*m^2]
r = 0.2;    %radius of the wheel [m]
n = 5;      %transmission ratio [-]

% Aerodynamic resistance
B0 = 2.5; %transverse [kg/m]

% Magic Formula Constants
MFC1 = [9.5 1.9 1.14  0.75];    %constants for dry asphalt
MFC2 = [2.5 1.8 1 0.2];         %constants for wet asphalt
MFC3 = [1.5 1.8 0.4 0.2];       %constants for icy surface

s= 0:0.01:1; %longitudal slip 
T1= N* MFC1(3)*sin(MFC1(2)*atan(MFC1(1)*s-MFC1(4)*(MFC1(1)*s-atan(MFC1(1)*s))));
T2= N* MFC2(3)*sin(MFC2(2)*atan(MFC2(1)*s-MFC2(4)*(MFC2(1)*s-atan(MFC2(1)*s))));
T3= N* MFC3(3)*sin(MFC3(2)*atan(MFC3(1)*s-MFC3(4)*(MFC3(1)*s-atan(MFC3(1)*s))));

% Slip regulator tuning parameters
DERIV_THRESHOLD = 0.4;
dM = [1 2 5 10 20 40 ];

CRITICAL_SLIP_VEL = 100;


% DC motor parameters
 %motor constants
k = 20;     % ?
B = 10;     % multiplies dFi (back-emf)

L = 0;
R = 0;

% PWM regulator params
Ua = 300;
Ra = 0.001;
Rb = 0.01; 

% Initial conditions
v0 = 1;     %initial velocity [m/s]


