% Load data
cruise1 = load('cruise1');
cruise2 = load('cruise2');
approach1 = load('approach1');
approach2 = load('approach2');

% Unpack eigenvalues
phugEigVal_c1 = cruise1.EigAnalysis.Phugoid.Pole;
shrtEigVal_c1 = cruise1.EigAnalysis.ShortPeriod.Pole;
attiEigVal_c1 = cruise1.EigAnalysis.AttitudeConDi.Pole;
dtchEigVal_c1 = cruise1.EigAnalysis.DutchRoll.Pole;
sprlEigVal_c1 = cruise1.EigAnalysis.Spiral.Pole;
rollEigVal_c1 = cruise1.EigAnalysis.Roll.Pole;
phugEigVal_c2 = cruise2.EigAnalysis.Phugoid.Pole;
shrtEigVal_c2 = cruise2.EigAnalysis.ShortPeriod.Pole;
attiEigVal_c2 = cruise2.EigAnalysis.AttitudeConDi.Pole;
dtchEigVal_c2 = cruise2.EigAnalysis.DutchRoll.Pole;
sprlEigVal_c2 = cruise2.EigAnalysis.Spiral.Pole;
rollEigVal_c2 = cruise2.EigAnalysis.Roll.Pole;
phugEigVal_a1 = approach1.EigAnalysis.Phugoid.Pole;
shrtEigVal_a1 = approach1.EigAnalysis.ShortPeriod.Pole;
attiEigVal_a1 = approach1.EigAnalysis.AttitudeConDi.Pole;
dtchEigVal_a1 = approach1.EigAnalysis.DutchRoll.Pole;
sprlEigVal_a1 = approach1.EigAnalysis.Spiral.Pole;
rollEigVal_a1 = approach1.EigAnalysis.Roll.Pole;
phugEigVal_a2 = approach2.EigAnalysis.Phugoid.Pole;
shrtEigVal_a2 = approach2.EigAnalysis.ShortPeriod.Pole;
attiEigVal_a2 = approach2.EigAnalysis.AttitudeConDi.Pole;
dtchEigVal_a2 = approach2.EigAnalysis.DutchRoll.Pole;
sprlEigVal_a2 = approach2.EigAnalysis.Spiral.Pole;
rollEigVal_a2 = approach2.EigAnalysis.Roll.Pole;

figure;
    hold on
    p1 = plot(real(phugEigVal_c1), imag(phugEigVal_c1),'om', real(phugEigVal_c1), -imag(phugEigVal_c1), 'om', 'MarkerSize', 10);
    p2 = plot(real(shrtEigVal_c1), imag(shrtEigVal_c1),'+m',  real(shrtEigVal_c1), -imag(shrtEigVal_c1), '+m', 'MarkerSize', 10);
    p3 = plot(real(attiEigVal_c1), imag(attiEigVal_c1),'*m', real(attiEigVal_c1), -imag(attiEigVal_c1), '*m',  'MarkerSize', 10);
    p4 = plot(real(phugEigVal_c2), imag(phugEigVal_c2),'og', real(phugEigVal_c2), -imag(phugEigVal_c2), 'og', 'MarkerSize', 10);
    p5 = plot(real(shrtEigVal_c2), imag(shrtEigVal_c2),'+g',  real(shrtEigVal_c2), -imag(shrtEigVal_c2), '+g', 'MarkerSize', 10);
    p6 = plot(real(attiEigVal_c2), imag(attiEigVal_c2),'*g', real(attiEigVal_c2), -imag(attiEigVal_c2), '*g',  'MarkerSize', 10);
    p7 = plot(real(phugEigVal_a1), imag(phugEigVal_a1),'or', real(phugEigVal_a1), -imag(phugEigVal_a1), 'or', 'MarkerSize', 10);
    p8 = plot(real(shrtEigVal_a1), imag(shrtEigVal_a1),'+r',  real(shrtEigVal_a1), -imag(shrtEigVal_a1), '+r', 'MarkerSize', 10);
    p9 = plot(real(attiEigVal_a1), imag(attiEigVal_a1),'*r', real(attiEigVal_a1), -imag(attiEigVal_a1), '*r',  'MarkerSize', 10);
    p10 = plot(real(phugEigVal_a2), imag(phugEigVal_a2),'ob', real(phugEigVal_a2), -imag(phugEigVal_a2), 'ob', 'MarkerSize', 10);
    p12 = plot(real(shrtEigVal_a2), imag(shrtEigVal_a2),'+b',  real(shrtEigVal_a2), -imag(shrtEigVal_a2), '+b', 'MarkerSize', 10);
    p13 = plot(real(attiEigVal_a2), imag(attiEigVal_a2),'*b', real(attiEigVal_a2), -imag(attiEigVal_a2), '*b',  'MarkerSize', 10);
    xlabel('Re');
    ylabel('Im');
    grid on
    gridxy(0,0);
       hleg1 = legend('Phugoid Mode (cg:1, 220kts)', 'Short Period Mode (cg:1, 220kts)', ...
        'Attitude Convergence/Divergence Mode (cg:1, 220kts)','Phugoid Mode (cg:2, 220kts)', 'Short Period Mode (cg:2, 220kts)', ...
        'Attitude Convergence/Divergence Mode (cg:2, 220kts)','Phugoid Mode (cg:1, 90kts)', 'Short Period Mode (cg:1, 90kts)', ...
        'Attitude Convergence/Divergence Mode (cg:1, 90kts)','Phugoid Mode (cg:2, 90kts)', 'Short Period Mode (cg:2, 90kts)', ...
        'Attitude Convergence/Divergence Mode (cg:2, 90kts)');
    set(hleg1, 'Location', 'Best');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]); 
    
    
    figure;
    hold on
    p1 = plot(real(dtchEigVal_c1), imag(dtchEigVal_c1), '^m', real(dtchEigVal_c1), -imag(dtchEigVal_c1), '^m', 'MarkerSize', 10);
    p2 = plot(real(sprlEigVal_c1), imag(sprlEigVal_c1), 'xm', real(sprlEigVal_c1), -imag(sprlEigVal_c1), 'xm', 'MarkerSize', 10);
    p3 = plot(real(rollEigVal_c1), imag(rollEigVal_c1), 'pm', real(rollEigVal_c1),-imag(rollEigVal_c1), 'pm', 'MarkerSize', 10);
    p4 = plot(real(dtchEigVal_c2), imag(dtchEigVal_c2), '^g', real(dtchEigVal_c2), -imag(dtchEigVal_c2), '^g', 'MarkerSize', 10);
    p5 = plot(real(sprlEigVal_c2), imag(sprlEigVal_c2), 'xg', real(sprlEigVal_c2), -imag(sprlEigVal_c2), 'xg', 'MarkerSize', 10);
    p6 = plot(real(rollEigVal_c2), imag(rollEigVal_c2), 'pg', real(rollEigVal_c2),-imag(rollEigVal_c2), 'pg', 'MarkerSize', 10);
    p7 = plot(real(dtchEigVal_a1), imag(dtchEigVal_a1), '^r', real(dtchEigVal_a1), -imag(dtchEigVal_a1), '^r', 'MarkerSize', 10);
    p8 = plot(real(sprlEigVal_a1), imag(sprlEigVal_a1), 'xr', real(sprlEigVal_a1), -imag(sprlEigVal_a1), 'xr', 'MarkerSize', 10);
    p9 = plot(real(rollEigVal_a1), imag(rollEigVal_a1), 'pr', real(rollEigVal_a1),-imag(rollEigVal_a1), 'pr', 'MarkerSize', 10);
    p10 = plot(real(dtchEigVal_a2), imag(dtchEigVal_a2), '^b', real(dtchEigVal_a2), -imag(dtchEigVal_a2), '^b', 'MarkerSize', 10);
    p11 = plot(real(sprlEigVal_a2), imag(sprlEigVal_a2), 'xb', real(sprlEigVal_a2), -imag(sprlEigVal_a2), 'xb', 'MarkerSize', 10);
    p12 = plot(real(rollEigVal_a2), imag(rollEigVal_a2), 'pb', real(rollEigVal_a2),-imag(rollEigVal_a2), 'pb', 'MarkerSize', 10);
    xlabel('Re');
    ylabel('Im');
    grid on
    gridxy(0,0);
    hleg2 = legend([p4, p5, p6],'Dutch Roll Mode (cg:1, 220kts)', 'Spiral Mode (cg:1, 220kts)', ...
        'Roll Mode (cg:1, 220kts)','Dutch Roll Mode (cg:2, 220kts)', 'Spiral Mode (cg:2, 220kts)', ...
        'Roll Mode (cg:2, 220kts)','Dutch Roll Mode (cg:1, 90kts)', 'Spiral Mode (cg:1, 90kts)', ...
        'Roll Mode (cg:1, 90kts)','Dutch Roll Mode (cg:2, 90kts)', 'Spiral Mode (cg:2, 90kts)', ...
        'Roll Mode (cg:2, 90kts)');
    set(hleg2, 'Location', 'Best');
    set(gcf, 'Color', [1 1 1]);
    set(gca, 'Color', [1 1 1]);