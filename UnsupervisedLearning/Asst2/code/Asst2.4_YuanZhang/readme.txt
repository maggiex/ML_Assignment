Asst2.4_YuanZhang

Code for Assignment 2 Bonus

(a) run LGSSM.m 

(c) run HoKalman.m     // this generates the initial parameters using HoKalman
    
    Then run EMFrame.m // this generates EM training curve from true parameters, 10 times random parameters and HoKalman parameters(for (b), (c) and (d)).


Other Files:

LGSSMEM.m            // main realization of LGSSM EM algorithm from some initial parameters.

LGSSMEM_initial.m    // this generates initial parameters.

ssm_kalman.m         // realization of kalman filtering and smoothing.