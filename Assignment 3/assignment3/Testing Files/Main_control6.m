% AERO3560 - Flight Mechanics 1 - Assignment 3 2018
% Author SID: 460369684
% Main Script

% Add every subfolder to path
folder = fileparts(which('Main.m')); 
addpath(genpath(folder));

clear;
clc;
clf;
clf reset;
close all;

% Plotting colors
red     = [0.8471 0.1176 0.1922];
blue    = [0.1059 0.3882 0.6157];
black   = [0 0 0];
green   = [0 0.5020 0];
cyan    = [0.0078 0.6627 0.8863];
yellow  = [0.9843 0.7608 0.0510];
gray    = [0.3490 0.3490 0.3490];
orange  = [1.0000 0.4980 0];
purple  = [0.5961 0.3059 0.6392];

% Plotting line width
lw = 1.2;

% Set plotting settings
set(groot,'defaultAxesColorOrder',[black;blue;red;green;yellow;cyan;...
    purple;orange]);
set(0,'defaultLineLineWidth',lw);

% Initialise aircraft parameters
[Nominal_params, Secondary_params] = initialisation;

flightCond = '1';

switch flightCond
    case '4'
    load ICs_PC9_CG2_100Kn_1000ft

    X0 = [X0(1:6); euler2quat(X0(7:9)); X0(10:end)];

    % Select CG position
    Params = Secondary_params;
    
    case '3'

    load ICs_PC9_CG2_180Kn_1000ft

    X0 = [X0(1:6); euler2quat(X0(7:9)); X0(10:end)];
    
    % Select CG position
    Params = Secondary_params;
    
    case '2'

    load ICs_PC9_nominalCG1_100Kn_1000ft

    X0 = [X0(1:6); euler2quat(X0(7:9)); X0(10:end)];

    % Select CG position
    Params = Nominal_params;
    
    case '1'

    load ICs_PC9_nominalCG1_180Kn_1000ft

    X0 = [X0(1:6); euler2quat(X0(7:9)); X0(10:end)];
    
    % Select CG position
    Params = Nominal_params;
end


% Trim aircraft
[X_trimmed, U_trimmed] = trim(Params, X0);

% Create time vector
timeEnd = 90;
dt = 0.01;
time = 0:dt:timeEnd;

% Set initial state
X(:,1) = X_trimmed;
U(:,1) = U_trimmed;

Xdot_trimmed = getstaterates(Params, X_trimmed, U_trimmed);
disp(Xdot_trimmed)

% Make estimates
[~, CL] = getstaterates(Params, X_trimmed, U_trimmed);
[U_manoeurve2, phi] = steadyHeadingSideslipEst(Params, U_trimmed, CL, deg2rad(5));

% U_turn = steadyTurnEstimate(Params, U_trimmed, aeroangles(X_trimmed), deg2rad(8.59522));

disp('------------------------------------------------------------')
fprintf('Controls for steady heading sideslip\n')
disp('------------------------------------------------------------')
fprintf('Required Aileron Deflection [rad]:\t %6.5e\n', rad2deg(U_manoeurve2(3)));
fprintf('Required Rudder Deflection [rad]:\t %6.5e\n', rad2deg(U_manoeurve2(4)));
fprintf('Required Bank Angle [deg]:\t\t\t %6.6f\n', rad2deg(phi));
disp('------------------------------------------------------------')
% fprintf('Controls for bank angle\n')
% disp('------------------------------------------------------------')
% fprintf('Required Aileron Deflection [rad]:\t %6.5e\n', U_turn(3));
% fprintf('Required Rudder Deflection [rad]:\t %6.5e\n', U_turn(4));
% disp('------------------------------------------------------------')

fprintf('Load the control input from "control6_fc1" into workspace, \nthen press any key to continue\n')
pause

clc

% Loop through time vector
for i = 2:length(time)
    
    % Run aircraft at trimmed settings for 1 second and then begin
    % simulation
    if time(i) <= 1
        
        % Determine new state
        [X_new] = rungeKutta4(Params,X(:,i-1),U_trimmed,dt);
        
        % Save result
        X(:,i) = X_new;
        U(:,i) = U_trimmed;
        
        % Show sideslip
        [~, ~, beta(i)] = aeroangles(X(:, i));
    else   
        
        % Determine control setting for manoeurve
        U_manoeurve = controls(U_trimmed, time(i), U_filter, ...
    T_filter);
% [~, CLflight(i), Y(i)] = getstaterates(Params, X(:,i-1), U_manoeurve);
% [~, Q] = flowproperties(X(:, i-1), aeroangles(X(:, i-1)));
% L(i) = CLflight(i)*Q*Params.Geo.S;

        % Determine new state
        [X_new] = rungeKutta4(Params,X(:,i-1),U_manoeurve,dt);
        
        % Save result
        X(:,i) = X_new;
        U(:,i) = U_manoeurve;
        
        % Show sideslip
        [~, ~, beta(i)] = aeroangles(X(:, i));
    end
end

% Plot results
% simulate(X)
plotData(X,U,time, true, '1')

fig = figure;
% subplot(3, 1, [1, 2])
euler = rad2deg(quat2euler(X(7:10, :)));
plot(time, euler(1, :), 'LineWidth', 2)
hold on
plot(time, euler(3, :), 'LineWidth', 2)
plot(time, rad2deg(beta), 'LineWidth', 2);
h = legend('Bank Angle', 'Heading', 'Sideslip', 'Location', 'best');
set(h,'Interpreter','latex');
grid on
print(fig, 'sideslip_plot', '-depsc')

xlim([0 60])
ylim([-20 50])

% subplot(3, 1, 3)
% euler = rad2deg(quat2euler(X(7:10, :)));
% plot(time, euler(1, :))
% hold on
% plot(time, euler(3, :))
% plot(time, rad2deg(beta));
% %plot(time, rad2deg(U(3, :)));
% grid on
% ylim([-20 65])

fprintf('\n\nFinal bank angle (t = 15s) [deg]: \t%6.6f\n', euler(1, time==12.5))
% fprintf('\n\nRequired bank angle (t = 30s) [deg]: \t%6.6f\n', rad2deg(-Y(time==30)/L(time==30)))
% 
% [X_trimmed2, U_trimmed2] = trim(Params, X(:, time == 46));