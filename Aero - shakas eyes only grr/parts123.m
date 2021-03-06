function parts123(n, nPts, U, AoA, Alpha0, A0, WingProps, TailProps, ...
    Model)

    % Aircraft angles of attack (rad)
    alpha = AoA.Radians;

    % Lifting line theory applied to main wing
    [Cw, WingAngles, WingProps, Wing] = liftingLineWing(n, nPts, alpha, ...
                                     Alpha0, A0, WingProps, U);

    % Unpack wing coefficient struct
    CL_w    = Cw.CL;
    Cdi_w   = Cw.Cdi;

    % Lifting line theory applied to tailplane
    [Ct, TailAngles, TailProps, Tail] = liftingLineTail(n, nPts, U, ...
                                        alpha, Alpha0, A0, WingProps, ...
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

    % Call DCBM function
    mode    = 1;
    Cdmin   = dragBuildUp(U, Model, mode);
    
    % Call miscellaneous component drag function
    Dq_misc = miscComponentDrag;
    Cd_misc = Dq_misc/WingProps.WingArea;
    
    % Update to obtain drag of piper warrior model
    Cd_model = Cdi_total' + Cdmin;
    
    % Include miscellaneous component drag
    Cd_aircraft = Cd_misc + Cd_model;
    
    % Call actual drag back calculation function
    [CD0_actual, CLmax_actual] = actualDrag;
    
    % Plot lift polar comparison between lifting line and experiment
    liftPolar = figure;
    plot(AoA.Degrees,Model.CL,'--o',AoA.Degrees,CL_total,'--d');
    hleg1 = legend('Experimental Data','Lifting Line Theory');
    xlabel('Angle of Attack (degrees)','FontSize',18);
    ylabel('Lift Coefficient','FontSize',18);
    set(hleg1,'Location','Best');
    hleg1.FontSize = 18;
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    grid on
    print(liftPolar,'liftPolar','-depsc');
    
    % Plot drag polar comparison between lifting line and experiment
    dragPolar = figure;
    plot(Model.CL, Model.Cd, '--o', CL_total, Cdi_total, '--d', ...
         CL_total, Cd_model, '--v', CL_total, Cd_aircraft, '--s');
    hold on
    plot(0, CD0_actual, 'x', 'LineWidth', 2);
    xlabel('Lift Coefficient','FontSize',18);
    ylabel('Drag Coefficient','FontSize',18);
    hleg2 = legend('Experimental Data','Lifting Line Theory', ...
        'DCBM','Complete Aircraft Estimate', 'Actual Drag');
    set(hleg2,'Location','Best');
    hleg2.FontSize = 18;
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    grid on
    print(dragPolar,'dragPolar','-depsc');
    
    % Unpack wing and tailplane downwash angles
    alpha_i_w = WingAngles.Downwash;
    alpha_i_t = TailAngles.Downwash;            % Downwash on tail
    
    % Unpack cartesian stations
    y_wing = Wing.SpanPos;
    y_tail = Tail.SpanPos;

    % Plot downwash angles - NORMAL LIFTING LINE
    liftingDownwash = figure;
    plot(y_wing,rad2deg(alpha_i_w(1,:)));
    hold on
    plot(y_tail,rad2deg(alpha_i_t(1,:)),'x');
    xlabel('Spanwise Position (m)','FontSize',18)
    ylabel('Downwash Angle (deg)','FontSize',18)
    hleg3 = legend('Produced by Wing','Incident on Tailplane');
    set(hleg3,'Location','Best');
    hleg3.FontSize = 18;
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    grid on
    print(liftingDownwash,'liftingDownwash','-depsc');
    
    % Unpack wing and tail chords
    c_w = WingProps.Chord;
    c_t = TailProps.Chord;
    
    % Plot wing chords
    wingChord = figure;
    plot(y_wing,c_w);
    ylim([0 max(c_w)]) 
    xlabel('Spanwise Position (m)','FontSize',18)
    ylabel('Wing Chord (m)','FontSize',18)
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    daspect([1 1 1]);
    grid on
    print(wingChord,'wingChord','-depsc');
    
    % Plot tailplane chords
    tailChord = figure;
    plot(y_tail,c_t);
    ylim([0 max(c_t)])
    xlabel('Spanwise Position (m)','FontSize',18)
    ylabel('Tailplane Chord (m)','FontSize',18)
    set(gca, 'XLimSpec', 'Tight');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);
    daspect([1 1 1]);
    grid on
    print(tailChord,'tailChord','-depsc');
    
end