% AERO3560 - Flight Mechanics 1 - Assignment 3 2018
% Author SID: 460369684
% Function Name: flowproperties
%
% Function Description:
%   Returns the air density and dynamic pressure, calculated as a function 
%   of aircraft altitude and speed
%
% Inputs:
%   Params: Struct containing all characteristics of the aircraft
%   V:      Total velocity magnitude (m/s)
%   U:      Vector containing all aircraft control settings. The order is:
%               - delta_t = U(1)    -
%               - delta_e = U(2)    (rad)
%               - delta_a = U(3)    (rad)
%               - delta_r = U(4)    (rad)
%
% Outputs:
%   U_turn:     Vector containing estimated control positions for steady
%               turn. The order is: 
%                   - delta_t = U(1)    -
%                   - delta_e = U(2)    (rad)
%                   - delta_a = U(3)    (rad)
%                   - delta_r = U(4)    (rad)
%   ratio:      Estimate ofratio of aileron to rudder during steady turn
%   BodyRates:  Struct contaiing estimated body yaw and pitch rates (rad/s)
%               during steady turn
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% TODO: none

function [U_turn, ratio, BodyRates] = steadyTurnEstimate(Params, U_trim, V)

    % Unpack aircraft characteristics
    g       = Params.Inertial.g;
    c       = Params.Geo.c;
    Cnr     = Params.Aero.Cnr;
    Cndr    = Params.Aero.Cndr;
    Cnda    = Params.Aero.Cnda;
    Clr     = Params.Aero.Clr;
    Cldr    = Params.Aero.Cldr;
    Clda    = Params.Aero.Clda;

    % Acceleration (g's) - defined by assignment
    nz = sqrt(2);
    
    % Calculate bank angle
    phi = acos(1/nz);
    
    % Calculate steady heading rate (rad/s)
    psi_dot = (g/V)*tan(phi);
    
    % Calculate yaw rate (rad/s)
    r = psi_dot*cos(phi);
    
    % Calculate pitch rate
    q = psi_dot*sin(phi);
    
    % Store body rates
    BodyRates.r = r;
    BodyRates.q = q;
    
    % Non-dimensionalise yaw rate
    r_hat = (r*c)/(2*V);
    
    % Estimate aileron deflection (rad)
    delta_a = ((Cldr*Cnr - Cndr*Clr)/(Cndr*Clda - Cldr*Cnda))*r_hat;       
    
    % Estimate rudder deflection
    delta_r = ((Cnda*Clr - Clda*Cnr)/(Cndr*Clda - Cldr*Cnda))*r_hat;
    
    % Output controls vector
    U_turn = [U_trim(1); U_trim(2); delta_a; delta_r];
    
    % Approximate ratio of aileron to rudder
    ratio = (Clr*Cndr)/(Cnr*Clda);
    
end