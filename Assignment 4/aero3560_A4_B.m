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

% Obtain lateral-directional state space model
[Alat, Blat] = lateralStateSpace(Params, V, theta, h);

% Create time vector for simulation
t_end = 60;
dt = 0.01;
time = 0:dt:t_end;

% Create state vector X = [u w q theta z v p r phi psi]'
X = [V 0 0 theta h 0 0 0 0 0]';

% Calculate time histories
[X_elevator,X_aileron, X_rudder] = deflections(X,time, Alat,A_lon5 ,Blat, B_lon5);



X_elevatorPlot = [X_elevator(1, :); X_elevator(6, :); X_elevator(2, :); ...
    X_elevator(7, :); X_elevator(3, :); X_elevator(8, :); ....
    euler2quat([X_elevator(9, :); X_elevator(4, :); X_elevator(10, :)]); ...
    zeros(size(X_elevator(1, :))); zeros(size(X_elevator(1, :))); ...
    X_elevator(5, :)];
X_aileronPlot = [X_aileron(1, :); X_aileron(6, :); X_aileron(2, :); ...
    X_aileron(7, :); X_aileron(3, :); X_aileron(8, :); ....
    euler2quat([X_aileron(9, :); X_aileron(4, :); X_aileron(10, :)]); ...
    zeros(size(X_aileron(1, :))); zeros(size(X_aileron(1, :))); ...
    X_aileron(5, :)];
X_rudderPlot = [X_rudder(1, :); X_rudder(6, :); X_rudder(2, :); ...
    X_rudder(7, :); X_rudder(3, :); X_rudder(8, :); ....
    euler2quat([X_rudder(9, :); X_rudder(4, :); X_rudder(10, :)]); ...
    zeros(size(X_rudder(1, :))); zeros(size(X_rudder(1, :))); ...
    X_rudder(5, :)];
% Plot results
plotData(X_elevatorPlot, time)