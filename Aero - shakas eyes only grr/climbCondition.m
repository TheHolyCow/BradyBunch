function climbCondition(n, nPts, U, Alpha0, A0, WingProps, TailProps, ...
    Model)

    % Aircraft climb angle (rad)
    alpha_climb = deg2rad(8);

    % Lifting line theory applied to main wing during climb
    [CwC, WingAnglesC, ~, ClimbWing] = liftingLineWing(n, nPts, ...
                                       alpha_climb, Alpha0, A0, WingProps, U);
                                   
    % Unpack wing coefficient struct
    CL_w   = CwC.CL;
    Cdi_w  = CwC.Cdi;
                                   
    % Unpack wing climb properties struct
    gamma_w     = ClimbWing.Gamma;
    effAlpha_w  = ClimbWing.EffectiveAlpha;
    y_wing      = ClimbWing.SpanPos;
    
    % Calculate lift
    gamma_w = (1.225*U).*gamma_w;

    % Stabilator deflection angle during climb (rad)
    deflec_up_climb = deg2rad(10);

    % Angle of attack of tail during climg (rad)
    alpha_t_climb = alpha_climb - deflec_up_climb;

    % Lifting line theory applied to tailplane
    [CtC, TailAnglesC, ~, ClimbTail] = liftingLineTail(n, nPts, U, ...
                                       alpha_t_climb, Alpha0, A0, ...
                                       WingProps, TailProps, WingAnglesC);
                                            
    % Unpack tail climb properties struct
    gamma_t     = ClimbTail.Gamma;
    effAlpha_t  = ClimbTail.EffectiveAlpha;
    y_tail      = ClimbTail.SpanPos;
    
    % Calculate lift
    gamma_t = (1.225*U).*gamma_t;
                                            
    % Unpack tailplane coefficient struct
    CL_t   = CtC.CL;
    Cdi_t  = CtC.Cdi;

    % Re-normalise w.r.t wing reference area
    CL_t_norm  = (CL_t.*(TailProps.TailArea.*mean(Model.DynP)))./ ...
                 (WingProps.WingArea.*mean(Model.DynP));
    Cdi_t_norm = (Cdi_t.*(TailProps.TailArea.*mean(Model.DynP)))./ ...
                 (WingProps.WingArea.*mean(Model.DynP));

    % Total lift during sustained bank
    CL_total = CL_w + CL_t_norm;

    % Total induced drag during sustained bank
    Cdi_total = Cdi_w + Cdi_t_norm;
    
    % Call miscellaneous component drag function
    Dq_misc = miscComponentDrag;
    Cd_misc = Dq_misc/WingProps.WingArea;
    
    % Call DCBM function
    mode    = 2;
    Cdmin   = dragBuildUp(U, Model, mode);

    % Update to obtain drag of piper warrior model
    Cd_model = Cdi_total' + Cdmin;
    
    % Include miscellaneous component drag
    Cd_aircraft = Cd_misc + Cd_model;
    
    % Print results to command window
    fprintf('--------------------- Climb --------------------')
    fprintf('\n')
    fprintf('Sustained Level Turn 3D Lift, CL: %.4g\n',CL_total)
    fprintf('Lifting Line Induced Drag, CDi: %.4g\n',Cdi_total)
    fprintf('DCBM Drag, CD: %.4g\n',Cd_aircraft)
    fprintf('\n')
    
    % Obtain vectors including left wing properties (flipping)
    y_wing_plot     = [-y_wing fliplr(y_wing)];
    y_tail_plot     = [-y_tail fliplr(y_tail)];
    wing_downwash   = [rad2deg(WingAnglesC.Downwash)...
                        fliplr(rad2deg(WingAnglesC.Downwash))];
    tail_downwash   = [rad2deg(TailAnglesC.Downwash)...
                        fliplr(rad2deg(TailAnglesC.Downwash))];
    gamma_w_plot    = [gamma_w fliplr(gamma_w)];
    gamma_t_plot    = [gamma_t fliplr(gamma_t)];
    effAlpha_w_plot = [effAlpha_w fliplr(effAlpha_w)];
    effAlpha_t_plot = [effAlpha_t fliplr(effAlpha_t)];
    
    % Plot downwash angles - CLIMB
    climbDownwash = figure;
    plot(y_wing_plot,wing_downwash);
    hold on
    plot(y_tail_plot,tail_downwash,'x');
    xlabel('Spanwise Position (m)','FontSize',18)
    ylabel('Downwash Angle (deg)','FontSize',18)
    hleg1 = legend('Produced by Wing','Incident on Tailplane');
    set(hleg1,'Location','Best');
    hleg1.FontSize = 18;
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    grid on
    print(climbDownwash,'climbDownwash','-depsc');
                                            
    % Lift distribution over wing with effective angle of attack
    climbWingLift = figure;
    yyaxis left
    plot(y_wing_plot,gamma_w_plot)
    ylabel('Lift (N)','FontSize',18)
    xlabel('Spanwise Position (m)','FontSize',18);
    yyaxis right
    plot(y_wing_plot,rad2deg(effAlpha_w_plot));
    ylabel('Local Angle of Attack (deg)','FontSize',18);
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    print(climbWingLift,'climbWingLift','-depsc');

    % Lift distribution over tail with effective angle of attack
    climbTailLift = figure;
    yyaxis left
    plot(y_tail_plot,gamma_t_plot);
    ylabel('Lift (N)','FontSize',18)
    xlabel('Spanwise Position (m)','FontSize',18);
    yyaxis right
    plot(y_tail_plot,rad2deg(effAlpha_t_plot));
    ylabel('Local Angle of Attack (deg)','FontSize',18);
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    print(climbTailLift,'climbTailLift','-depsc');
    
end