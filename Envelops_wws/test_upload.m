clear all 
close all

Ficheix1_phasejump_underDamped = readmatrix('FICHEIX.1GFM behavior (phase jump)_UnderDamped.xlsm', 'Sheet','Second Order V3','Range','A7:Q1495');
F1_PhJ_UD.t1                               = Ficheix1_phasejump_underDamped(:,1);
F1_PhJ_UD.Enveloppe_avec_marge_tunnel_10ms = Ficheix1_phasejump_underDamped(:,2:3);     % min and max values
F1_PhJ_UD.Expected_minumum                 = Ficheix1_phasejump_underDamped(:,4);       % Expected minumum exponential response with x margin
F1_PhJ_UD.expecter_behavior                = Ficheix1_phasejump_underDamped(:,5);


F1_PhJ_UD.t2                               = Ficheix1_phasejump_underDamped(1:264,1);   % time dimesion corresonping to following data
F1_PhJ_UD.expecter_behavior_valuesH_D      = Ficheix1_phasejump_underDamped(1:264,6:7); % min and max values;
F1_PhJ_UD.expected_TP2_10msDelay           = Ficheix1_phasejump_underDamped(1:264,8);   % Expected second order response with 10 ms delay (only at begining)
F1_PhJ_UD.expected_TP2_MG_10msDely         = Ficheix1_phasejump_underDamped (1:264,9);  % Expected second order response with margin up and with 10 ms delay
F1_PhJ_UD.expected_TP2_MG_NODely           = Ficheix1_phasejump_underDamped (1:264,10);  % Expected second order response with margin (high) NO delay
F1_PhJ_UD.expected_TP2_MG_Minus            = Ficheix1_phasejump_underDamped (1:264,11);  % Expected second order response with margin (high) -tunnel
F1_PhJ_UD.expected_TP2_MG_Plus             = Ficheix1_phasejump_underDamped (1:264,12);  % Expected second order response with margin (high) +tunnel
F1_PhJ_UD.expected_TP2_MG_Low              = Ficheix1_phasejump_underDamped (1:264,13);  % Expected second order response with 10 ms delay and low margin
F1_PhJ_UD.expected_Enveloppe               = Ficheix1_phasejump_underDamped (1:264,14);  % using the expected envelope as a max when the damped sinusoid decreases
F1_PhJ_UD.expected_Enveloppe_min           = Ficheix1_phasejump_underDamped (1:264,15);  % Envelope min - band finale
F1_PhJ_UD.P_up_down                        = Ficheix1_phasejump_underDamped(1:264,16:17); % Power up and down values


Ficheix1_phasejump_OverDamped = readmatrix('FICHEIX.1GFM behavior (phase jump)_OverDamped.xlsm', 'Sheet','Overdamped V3','Range','A5:J268');
F1_PhJ_OD.t1                               = Ficheix1_phasejump_OverDamped(:,1);
F1_PhJ_OD.VSM                              = Ficheix1_phasejump_OverDamped(:,3);        % Theoretical response from VSM
F1_PhJ_OD.Highest_value                    = Ficheix1_phasejump_OverDamped(:,4);        % Highest value (multiplied by 1+magin) and taking tunnel into account
F1_PhJ_OD.Ptheorique_min_max               = Ficheix1_phasejump_OverDamped(:,5:6);      % Ptheorique min and max values
F1_PhJ_OD.Value_10ms                       = Ficheix1_phasejump_OverDamped(:,7);        % valeur basse (Multiplié par marge basse + décalage 10ms)
F1_PhJ_OD.Value_200ms                      = Ficheix1_phasejump_OverDamped(:,8);        % valeur bassee (Multiplié par marge basse + tunnel à partir de 200ms)
F1_PhJ_OD.P_down_up                        = Ficheix1_phasejump_OverDamped(:,9:10);     % down (first) and up (second) value of P


Ficheix2_amplitudeStep   = readmatrix('FICHEIX.2GFM behavior (amplitude step).xlsm', 'Sheet','Amplitude Jump','Range','A5:F268');
F2_AmpStep.t1                               = Ficheix2_amplitudeStep(:,1);               
F2_AmpStep.Q_min_max                        = Ficheix2_amplitudeStep(:,2:3);             % min and max values of Q
F2_AmpStep.Q_expected                       = Ficheix2_amplitudeStep(:,4);               % expected values of Q
F2_AmpStep.Q_down_up                        = Ficheix2_amplitudeStep(:,5:6);             % down (first) and up (second) values of Q


Ficheix3_inertia = readmatrix('FICHEIX.3GFM behavior (inertia).xlsm', 'Sheet','Rocof','Range','A7:X1495');
F3_Inertia.t1                               = Ficheix3_inertia(:,1);
F3_Inertia.Enveloppe_avec_marge_tunnel_10ms = Ficheix3_inertia(:,2);         % Enveloppe min avec marge et tunnel et +10ms
F3_Inertia.Enveloppe_max_min                = Ficheix3_inertia(:,3:4);       % enveloppe max and min avec marge
F3_Inertia.Enveloppe_avec_marge_tunnel_exp  = Ficheix3_inertia(:,5);         % Enveloppe min avec marge et tunnel et exp
F3_Inertia.expecter_behavior                = Ficheix3_inertia(:,6);         % expecter behavior
F3_Inertia.expecter_behavior_min_max        = Ficheix3_inertia(:,7:8);       % expecter behavior (min values) and max values
F3_Inertia.P_up_down                        = Ficheix3_inertia(:,9:10);      % up and down of P

%load data;

