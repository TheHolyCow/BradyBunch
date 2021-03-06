% AERO3560 - Flight Mechanics 1 - Assignment 3 2018
% Author SID: 460306678
% Function Name: controls
%
% Function Description:
%   Determines the control input vector for a manoeuvre
%
% Inputs:
%   U:          Vector containing all aircraft control settings. The order is:
%                   - delta_t = U(1)    -
%                   - delta_e = U(2)    (rad)
%                   - delta_a = U(3)    (rad)
%                   - delta_r = U(4)    (rad)
%   Time:       Time simulation vector
%   CurrentTime:Current time of the simutlation 
%
% Outputs:
%   U_manoeuvre:  Aircraft state at end of time step. Same order and units as 
%           'X0', listed above
%
% Other m-files required:
%   None
%
% Subfunctions:
%   None
%
% MAT-files required: none
%
% TODO: 
%   FINISH THIS FUNCTION

function [U_manoeurve, phi] = steadyHeadingSideslipEst(Params, U_trimmed, CL, beta)
    
    % Set new vector
    U_manoeurve = U_trimmed;
    
    % Extract aircraft aero parameters
    Clda = Params.Aero.Clda;
    Cldr = Params.Aero.Cldr;
    Cnda = Params.Aero.Cnda;
    Cndr = Params.Aero.Cndr;
    Cyda = Params.Aero.Cyda;
    Cydr = Params.Aero.Cydr;
    Cyb = Params.Aero.Cyb;
    Clb = Params.Aero.Clb;
    Cnb = Params.Aero.Cnb;
    control_min = Params.ControlLimits.Lower;
    control_max = Params.ControlLimits.Upper;

    A = [CL Cyda Cydr
        0 Clda Cldr
        0 Cnda Cndr];
    y = [-Cyb
        -Clb
        -Cnb]*beta;
    x = linsolve(A, y);
    phi = x(1);

    % Control inputs required for a sideslip of 5 degrees
    U_manoeurve(3:end) = x(2:end);

    % Check if exceeding control limits
    if any(U_manoeurve > control_max) || any(U_manoeurve < control_min)

        % Reset control to control maximum and minimum
        if any(U_manoeurve> control_max)
            U_manoeurve(U_manoeurve> control_max) = control_max(U_manoeurve> control_max);
        else
            U_manoeurve(U_manoeurve< control_min) = control_min(U_manoeurve< control_min);
        end
    end
end