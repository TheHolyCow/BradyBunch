% AERO3560 Assignment 4

% Make CSV
lateral = [EigAnalysis.DutchRoll.Pole, EigAnalysis.DutchRoll.Damping, EigAnalysis.DutchRoll.Wn, 1/EigAnalysis.DutchRoll.Wn;
           EigAnalysis.Spiral.Pole, EigAnalysis.Spiral.Damping, EigAnalysis.Spiral.Wn, 1/EigAnalysis.Spiral.Wn;
           EigAnalysis.Spiral.Pole, EigAnalysis.Spiral.Damping, EigAnalysis.Spiral.Wn, 1/EigAnalysis.Spiral.Wn;
           EigAnalysis.Roll.Pole, EigAnalysis.Roll.Damping, EigAnalysis.Roll.Wn, 1/EigAnalysis.Roll.Wn];
       
longitudinal = [EigAnalysis.ShortPeriod.Pole, EigAnalysis.ShortPeriod.Damping, EigAnalysis.ShortPeriod.Wn, 1/EigAnalysis.ShortPeriod.Wn;
                EigAnalysis.ShortPeriod.Pole, EigAnalysis.ShortPeriod.Damping, EigAnalysis.ShortPeriod.Wn, 1/EigAnalysis.ShortPeriod.Wn;
           EigAnalysis.Phugoid.Pole, EigAnalysis.Phugoid.Damping, EigAnalysis.Phugoid.Wn, 1/EigAnalysis.Phugoid.Wn;
           EigAnalysis.Phugoid.Pole, EigAnalysis.Phugoid.Damping, EigAnalysis.Phugoid.Wn, 1/EigAnalysis.Phugoid.Wn;
           EigAnalysis.AttitudeConDi.Pole, EigAnalysis.AttitudeConDi.Damping, EigAnalysis.AttitudeConDi.Wn, 1/EigAnalysis.AttitudeConDi.Wn];

csvwrite('lateral1.txt',lateral)
csvwrite('longitudinal1.txt',longitudinal)
