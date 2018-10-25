function bankCondition(nPts, U, Alpha0, A0, WingProps, TailProps, Model)

    % Aircraft pitch angle of 2 degrees (rad)
    alpha_pitch = deg2rad(2);

    % Call function for banked turn lifting line theory on wing
    [CwB, WingAnglesB, ~, BankWing] = liftingLineBankWing(nPts, ...
                                      alpha_pitch, Alpha0, A0, WingProps, U);

    % Unpack wing bank properties struct
    gamma_w     = BankWing.Gamma;
    effAlpha_w  = BankWing.EffectiveAlpha;
    y_wing      = BankWing.SpanPos;

    % Unpack wing coefficient struct
    CL_w   = CwB.CL;
    Cdi_w  = CwB.Cdi;

    % Stabilator deflection angle during sustained bank (rad)
    deflec_up = deg2rad(3);

    % Angle of attack of tail during sustained bank (rad)
    alpha_t = alpha_pitch - deflec_up;

    [CtB, TailAnglesB, ~, BankTail] = liftingLineTailBank(nPts, ...
                                      alpha_t, U, Alpha0, A0, ...
                                      WingProps, TailProps, WingAnglesB);   

    % Unpack wing bank properties struct
    gamma_t     = BankTail.Gamma;
    effAlpha_t  = BankTail.EffectiveAlpha;
    y_tail = BankTail.SpanPos;

    % Unpack tailplane coefficient struct
    CL_t   = CtB.CL;
    Cdi_t  = CtB.Cdi;

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
    fprintf('------------- Sustained Level Turn -------------')
    fprintf('\n')
    fprintf('Sustained Level Turn 3D Lift, CL: %.4g\n',CL_total)
    fprintf('Examlpe Induced Drag, CDi: %.4g\n',Cdi_total)
    fprintf('\n')

    % Plot downwash angles - BANKED TURN
    figure;
    plot(y_wing,rad2deg(WingAnglesB.Downwash));
    hold on
    plot(y_tail,rad2deg(TailAnglesB.Downwash),'x');
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
    plot(y_wing,gamma_w)
    ylabel('Circulation')
    xlabel('Spanwise Position (m)');
    yyaxis right
    plot(y_wing,rad2deg(effAlpha_w));
    ylabel('Local Angle of Attack (deg)');
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);

    % Lift distribution over tail with effective angle of attack
    figure;
    yyaxis left
    plot(y_tail,gamma_t);
    ylabel('Circulation')
    xlabel('Spanwise Position (m)');
    yyaxis right
    plot(y_tail,rad2deg(effAlpha_t));
    ylabel('Local Angle of Attack (deg)');
    grid on
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    
end