% Clear command window and reset figure properties
clear;
clc;
clf;
clf reset;
close all;

% Load .mat file for CG2 at 220 kts
load A_lon_220Kn_500ft_CG2.mat

% Load aircraft properties
Params = aero3560_LoadFlightDataPC9_CG2;

% Flight speed
V = convvel(220,'kts','m/s');

% Density at flight speed
h               = convlength(500,'ft','m');
[~, ~, ~, rho]  = atmosisa(h);

% Pitch angle at steady level flight (radians)
theta = 0;

% Unpack intertial data
g   = Params.Inertial.g;
m   = Params.Inertial.m;
Ixx = Params.Inertial.Ixx;
Izz = Params.Inertial.Izz;
Ixz = Params.Inertial.Ixz;

% Unpack geometric data
S   = Params.Geo.S;
b   = Params.Geo.b;

% Unpack side force coefficients
Cyb = Params.Aero.Cyb;
Cyp = Params.Aero.Cyp;
Cyr = Params.Aero.Cyr;

% N Moment Coefficients
Cnb = Params.Aero.Cnb;
Cnp = Params.Aero.Cnp;
Cnr = Params.Aero.Cnr;

% L Moment Coefficients
Clb = Params.Aero.Clb;
Clp = Params.Aero.Clp;
Clr = Params.Aero.Clr;

% Calculate aerodynamic derivatives for A matrix
Q   = (1/2)*rho*V^2;
Yv  = (1/m)*Q*S*(V*Cyb);
Yp  = (1/m)*Q*S*(Cyp);
Yr  = (1/m)*Q*S*(Cyr);
Lv  = (1/Ixx)*Q*S*b*(V*Clb);
Lp  = (1/Ixx)*Q*S*b*(Clp);
Lr  = (1/Ixx)*Q*S*b*(Clr);
Nv  = (1/Izz)*Q*S*b*(V*Cnb);
Np  = (1/Izz)*Q*S*b*(Cnp);
Nr  = (1/Izz)*Q*S*b*(Cnr);
NTv = 0;
A1  = Ixz/Ixx;
B1  = Ixz/Izz;

% Calculate elements of A matrix
A11 = Yv;
A12 = Yp;
A13 = Yr - V;
A14 = g*cos(theta);
A15 = 0;
A21 = (Lv + A1*(Nv + NTv))/(1 - A1*B1);
A22 = (Lp + A1*Np)/(1 - A1*B1);
A23 = (Lr + A1*Nr)/(1 - A1*B1);
A24 = 0;
A25 = 0;
A31 = ((Nv + NTv) + B1*Lv)/(1 - A1*B1);
A32 = (Np + B1*Lp)/(1 - A1*B1);
A33 = (Nr + B1*Lr)/(1 - A1*B1);
A34 = 0;
A35 = 0;
A41 = 0;
A42 = 1;
A43 = tan(theta);
A44 = 0;
A45 = 0;
A51 = 0;
A52 = 0;
A53 = sec(theta);
A54 = 0;
A55 = 0;

% Create lateral A matrix
Alat = [A11 A12 A13 A14 A15;
        A21 A22 A23 A24 A25;
        A31 A32 A33 A34 A35;
        A41 A42 A43 A44 A45;
        A51 A52 A53 A54 A55];
