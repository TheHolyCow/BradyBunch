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

    % Stabilator deflection angle during climb (rad)
    deflec_up_climb = deg2rad(10);

    % Angle of attack of tail during climg (rad)
    alpha_t_climb = alpha_climb - deflec_up_climb;

    % Lifting line theory applied to tailplane
    [CtC, TailAnglesC, TailPropsC, ClimbTail] = liftingLineTail(n, nPts, U, ...
                                                alpha_t_climb, Alpha0, A0, ...
                                                WingProps, TailProps, ...
                                                WingAnglesC);
                                            
    % Unpack tail climb properties struct
    gamma_t     = ClimbTail.Gamma;
    effAlpha_t  = ClimbTail.EffectiveAlpha;
    y_tail      = ClimbTail.SpanPos;
                                            
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
    
    % Print results to command window
    fprintf('--------------------- Climb --------------------')
    fprintf('\n')
    fprintf('Sustained Level Turn 3D Lift, CL: %.4g\n',CL_total)
    fprintf('Examlpe Induced Drag, CDi: %.4g\n',Cdi_total)
    fprintf('\n')
    
    % Obtain vectors including left wing properties
    y_wing_plot     = [-fliplr(y_wing) y_wing];
    y_tail_plot     = [-fliplr(y_tail) y_tail];
    wing_downwash   = [fliplr(rad2deg(WingAnglesC.Downwash)) ...
                       rad2deg(WingAnglesC.Downwash)];
    tail_downwash   = [fliplr(rad2deg(TailAnglesC.Downwash)) ...
                       rad2deg(TailAnglesC.Downwash)];
    gamma_w_plot    = [fliplr(gamma_w) gamma_w];
    gamma_t_plot    = [fliplr(gamma_t) gamma_t];
    effAlpha_w_plot = [fliplr(effAlpha_w) effAlpha_w];
    effAlpha_t_plot = [fliplr(effAlpha_t) effAlpha_t];
    
    % Plot downwash angles - CLIMB
    figure;
    plot(y_wing_plot,wing_downwash);
    hold on
    plot(y_tail_plot,tail_downwash,'x');
    xlabel('Spanwise Position (m)')
    ylabel('Downwash Angle (deg)')
    hleg1 = legend('Produced by Wing','Incident on Tailplane');
    set(hleg1,'Location','Best');
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    grid on
                                            
    % Lift distribution over wing with effective angle of attack
    figure;
    yyaxis left
    plot(y_wing_plot,gamma_w_plot)
    ylabel('Circulation')
    xlabel('Spanwise Position (m)');
    yyaxis right
    plot(y_wing_plot,rad2deg(effAlpha_w_plot));
    ylabel('Local Angle of Attack (deg)');
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);

    % Lift distribution over tail with effective angle of attack
    figure;
    yyaxis left
    plot(y_tail_plot,gamma_t_plot);
    ylabel('Circulation')
    xlabel('Spanwise Position (m)');
    yyaxis right
    plot(y_tail_plot,rad2deg(effAlpha_t_plot));
    ylabel('Local Angle of Attack (deg)');
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    
end