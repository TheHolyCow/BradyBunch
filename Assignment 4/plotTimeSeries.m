function [fig1, fig2, fig3, fig4] = plotTimeSeries(V, X, time, tlim, plotResults)

    % For state vector, X = [u w q theta z v p r phi psi]'
    
    if plotResults

        % Plot aerodynamic angles
        fig1 = figure;
        plot(time, rad2deg(X(2, :)/V));
        hold on
        plot(time, rad2deg(X(6, :)/V));
        leg = legend('\alpha', '\beta', 'Location', 'best');
        xlabel('Time (sec)')
        ylabel('Aerodynamic Angles (deg)')
        set(gca, 'XLimSpec', 'Tight');
        set(gcf, 'Color', [1 1 1]);
        set(gca, 'Color', [1 1 1]);
        grid on
        print(fig1, 'cruise2_tSeries_elevator_alphaBeta', '-depsc') 
        
        % Plot body rates
        fig2 = figure;
        plot(time, rad2deg(X(7, :)));
        hold on
        plot(time, rad2deg(X(3, :)));
        plot(time, rad2deg(X(8, :)));
        leg = legend('p', 'q', 'r', 'Location', 'best');
        xlabel('Time (sec)')
        ylabel('Body Axes Rotation Rates (deg/s)')
        set(gca, 'XLimSpec', 'Tight');
        set(gcf, 'Color', [1 1 1]);
        set(gca, 'Color', [1 1 1]);
        grid on
        print(fig2, 'cruise2_tSeries_elevator_rotRates', '-depsc') 
        
        % Plot body angles 
        fig3 = figure;
        plot(time, rad2deg(X(9, :)));
        hold on
        plot(time, rad2deg(X(4, :)));
        plot(time, rad2deg(X(10, :)));
        leg = legend('\phi', '\theta', '\psi', 'Location', 'best');
        xlabel('Time (sec)')
        ylabel('Body Axes Attitude Angles (deg)')
        set(gca, 'XLimSpec', 'Tight');
        set(gcf, 'Color', [1 1 1]);
        set(gca, 'Color', [1 1 1]);
        grid on
        print(fig3, 'cruise2_tSeries_elevator_attitudes', '-depsc') 
        
        % Plot body velocity 
        fig4 = figure;
        plot(time, X(1, :));
        hold on
        plot(time, X(6, :));
        plot(time, X(2, :));
        leg = legend('u', 'v', 'w', 'Location', 'best');
        xlabel('Time (sec)')
        ylabel('Body Axes Velocities (m/s)')
        set(gcf, 'Color', [1 1 1]);
        set(gca, 'Color', [1 1 1]);
        set(gca, 'XLimSpec', 'Tight');
        grid on
        print(fig4, 'cruise2_tSeries_elevator_velocities', '-depsc') 
    end
        
end