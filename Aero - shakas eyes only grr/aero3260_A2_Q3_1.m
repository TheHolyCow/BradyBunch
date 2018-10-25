% Clear command window and reset figure properties
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

%% Common wing/tail properties
% Call validation case function
validationCase;

% Lift curve slope (rad^-1)
A0.naca0012     = 1.4/(deg2rad(13.189));    % NACA0012
A0.naca65415    = 1.6/(deg2rad(15));        % NACA 65-415

% Zero lift AoA (rad)
Alpha0.naca0012     = 0;                    % NACA0012
Alpha0.naca65415    = -deg2rad(2);          % NACA 65-415

% Wing, tail and fuselage geometry
[WingProps, TailProps, FuseProps] = aircraftProps;

% Load experimental data files
[Model, AoA, U] = loadExperiment;

% Aircraft angles of attack (rad)
alpha = AoA.Radians;

% Number of control points
nPts = 1000;

% Generate vector of odd numbers (symmetrical wing/tailplane)
n = 2*(1:nPts) - 1;

%% Lifting line theory
% Lifting line theory applied to main wing
[Cw, WingAngles, WingProps] = liftingLineWing(n, nPts, alpha, Alpha0, ...
                              A0, WingProps);

% Unpack wing coefficient struct
CL_w    = Cw.CL;
Cdi_w   = Cw.Cdi;

% Lifting line theory applied to tailplane
[Ct, TailAngles, TailProps, CartStn] = liftingLineTail(n, nPts, alpha, ...
                                       Alpha0, A0, WingProps, ...
                                       TailProps, WingAngles);

% Unpack tailplane coefficient struct
CL_t    = Ct.CL;
Cdi_t   = Ct.Cdi;

% Re-normalise w.r.t wing reference area
CL_t_norm   = (CL_t.*(TailProps.TailArea.*Model.DynP'))./...
              (WingProps.WingArea.*Model.DynP');
Cdi_t_norm  = (Cdi_t.*(TailProps.TailArea.*Model.DynP'))./...
              (WingProps.WingArea.*Model.DynP');

% Total lift
CL_total = CL_w + CL_t_norm;

% Total induced drag
Cdi_total = Cdi_w + Cdi_t_norm;

%% DCBM for wind tunnel model
% Call DCBM function
Cdmin = dragBuildUp(U, WingProps, TailProps, FuseProps, AoA);

% Update to obtain drag of piper warrior model
Cd_model = Cdi_total' + Cdmin;

%% Climb condition


%% Sustained bank condition
% Aircraft pitch angle of 2 degrees (rad)
alpha_pitch = deg2rad(2);

% Call function for banked turn lifting line theory on wing
[CwB, WingAnglesB, WingPropsB, BankWing] = liftingLineBankWing(nPts, ...
                                            alpha_pitch, Alpha0, A0, ...
                                            WingProps, U);

% Unpack wing bank properties struct
gamma_w     = BankWing.Gamma;
effAlpha_w  = BankWing.EffectiveAlpha;
y_wing_bank = BankWing.SpanPos;

% Unpack wing coefficient struct
CL_w_bank   = CwB.CL;
Cdi_w_bank  = CwB.Cdi;

% Stabilator deflection angle
deflec_up = deg2rad(3);

% Angle of attack of tail
alpha_tail = alpha_pitch - deflec_up;
                                       
[CtB, TailAnglesB, TailPropsB, BankTail] = liftingLineTailBank(nPts, ...
                                           alpha_tail, U, Alpha0, A0, ...
                                           WingProps, TailProps, ...
                                           WingAnglesB);   
                                       
% Unpack wing bank properties struct
gamma_t     = BankTail.Gamma;
effAlpha_t  = BankTail.EffectiveAlpha;
y_tail_bank = BankTail.SpanPos;

                                       
% Unpack tailplane coefficient struct
CL_t_bank   = CtB.CL;
Cdi_t_bank  = CtB.Cdi;

% Re-normalise w.r.t wing reference area
CL_t_norm_bank  = (CL_t_bank.*(TailProps.TailArea.*mean(Model.DynP)))./...
                  (WingProps.WingArea.*mean(Model.DynP));
Cdi_t_norm_bank = (Cdi_t_bank.*(TailProps.TailArea.*mean(Model.DynP)))./...
                  (WingProps.WingArea.*mean(Model.DynP));
              
% Total lift during sustained bank
CL_total_bank = CL_w_bank + CL_t_norm_bank;

% Total induced drag during sustained bank
Cdi_total_bank = Cdi_w_bank + Cdi_t_norm_bank;
                         
%% Display results
% Unpack cartesian stations
y_wing = CartStn.Wing;
y_tail = CartStn.Tail;

% Unpack wing and tail chords
c_w = WingProps.Chord;
c_t = TailProps.Chord;

% Unpack wing and tailplane downwash angles
alpha_i_w = WingAngles.Downwash;
alpha_i_t = TailAngles.Downwash;            % Downwash on tail

% Plot wing chords
figure;
plot(y_wing,c_w);
ylim([0 max(c_w)]) 
xlabel('Spanwise Position (m)')
ylabel('Wing Chord (m)')
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
daspect([1 1 1]);
grid on

% Plot tailplane chords
figure;
plot(y_tail,c_t);
ylim([0 max(c_t)])
xlabel('Spanwise Position (m)')
ylabel('Tailplane Chord (m)')
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
daspect([1 1 1]);
grid on

% Plot downwash angles - NORMAL LIFTING LINE
figure;
plot(y_wing,rad2deg(alpha_i_w(1,:)),'-x');
hold on
plot(y_tail,rad2deg(alpha_i_t(1,:)),'o','color',red);
xlabel('Spanwise Position (m)')
ylabel('Downwash Angle (deg)')
hleg1 = legend('Produced by Wing','Seen by Tail');
set(hleg1,'Location','Best');
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
grid on

% Plot downwash angles - BANKED TURN
figure;
plot(y_wing_bank,rad2deg(WingAnglesB.Downwash),'-x');
xlabel('Spanwise Position (m)')
ylabel('Downwash Angle (deg)')
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
grid on

% Plot lift polar comparison between lifting line and experiment
figure;
plot(AoA.Degrees,Model.CL,'--o',AoA.Degrees,CL_total,'--d');
hleg1 = legend('Experimental Data','Lifting Line Theory');
xlabel('Angle of Attack (degrees)');
ylabel('Lift Coefficient');
set(hleg1,'Location','Best');
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
grid on

% Plot drag polar comparison between lifting line and experiment
figure;
plot(Model.CL,Model.Cd,'--o',CL_total,Cdi_total,'--d',CL_total,Cd_model,'--v');
hleg1 = legend('Experimental Data','Lifting Line Theory','DCBM');
xlabel('Lift Coefficient');
ylabel('Drag Coefficient');
set(hleg1,'Location','Best');
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
grid on

% Lift distribution over wing with effective angle of attack
figure;
yyaxis left
plot(y_wing_bank,gamma_w)
ylabel('Circulation')
xlabel('Spanwise Position (m)');
yyaxis right
plot(y_wing_bank,rad2deg(effAlpha_w));
ylabel('Local Angle of Attack (deg)');
grid on
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);

figure;
yyaxis left
plot(y_tail_bank,gamma_t);
ylabel('Circulation')
xlabel('Spanwise Position (m)');
yyaxis right
plot(y_tail_bank,rad2deg(effAlpha_t));
ylabel('Local Angle of Attack (deg)');
grid on
set(gca, 'XLimSpec', 'Tight');
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);

% % Plot wing-fuselage interference factor
% figure;
% semilogx(Rwf(:,1)*1e6,Rwf(:,2))
% xlabel('Reynolds Number, Re','interpreter','latex')
% ylabel('Interference Factor, $R_{wb}$','interpreter','latex')
% set(gca, 'XLimSpec', 'Tight');
% set(gcf, 'Color', [1 1 1]);
% set(gca, 'Color', [1 1 1]);
% grid on