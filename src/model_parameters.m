function [params] = model_parameters(need_set)
persistent params_p
if nargin < 1 || ~need_set
    params = params_p;
    return;
end
params = struct;

%% Timeline
params.t_end_pre_training = 1.1;
params.t_end_test_cycle = 7.3;
params.step = 0.0001;
params.n_pre_training = fix(params.t_end_pre_training / params.step);
params.n_test = fix(params.t_end_test_cycle / params.step) + 1;

%% Experiment
params.t_start_stim = 0.02;
params.training_impulse_duration = 0.002;
params.training_impulse_T = 0.005;
params.test_impulse_duration = 0.02;
params.test_impulse_T = 0.07;
params.t_pause_test_cycle = 0.65;

params.Iapp_training = 80;
params.Iapp_test = 8;
params.N_patterns = 20;
params.N_present = 10;
params.N_patterns_1_cycle = 7;
params.N_cycles = 10;

%% Applied pattern current
params.variance_training = 0.05;
params.variance_test = 0.2;

%% Runge-Kutta steps
params.u2 = params.step / 2;
params.u6 = params.step / 6;

%% Network size
params.mneuro_E = 79;
params.nneuro_E = 79;
params.mneuro_I = 40;
params.nneuro_I = 40;
params.quantity_neurons_E = params.mneuro_E * params.nneuro_E;
params.quantity_neurons_I = params.mneuro_I * params.nneuro_I;
params.mastro = 26;
params.nastro = 26;
az = 4; % Astrosyte zone size
params.az = az - 1;

%% Initial conditions
params.v_0 = -70;
params.V_0 = -71.9795475755463;
params.U_0 = -12.8842919091830;
params.ca_0 = 0.072495;
params.h_0 = 0.886314;
params.ip3_0 = 0.820204;

%% Neuron mode
params.aa = 0.1; %FS
params.b = 0.2;
params.c = -65;
params.d = 2;
params.alf = 50;
params.k = 600;
params.neuron_fired_thr = 30;
params.G_thr = 0.2;

%% Synaptic connections
params.N_connections_EE = 200; % number of connections between neurons in first layer
params.quantity_connections_EE = params.quantity_neurons_E * params.N_connections_EE;
params.N_connections_IE = 5; % number of connections between neurons from first layer to second layer
params.quantity_connections_IE = params.quantity_neurons_E * params.N_connections_IE;
params.N_connections_EI = 2000; % maximum number of connections between neurons from second layer to first layer
params.quantity_connections_EI = params.quantity_neurons_I * params.N_connections_EI;

params.W_EE_0 = 0.0001;
params.W_EI_0 = 0.0001;
params.delta_gsynEE = 0.007;
params.max_gsynEE = 0.05;
params.gsynIE = 0.1;
params.delta_gsynEI = 0.007;
params.max_gsynEI = 0.05;
params.W_IE = 0.1;

params.aep = 2; % astrocyte effect parameter
params.Esyn = 0;
params.Esyn_ = -90;
params.ksyn = 0.2;

params.lambda_EE = 15;
params.lambda_IE = 2;
params.lambda_EI = 80;
params.beta = 200;

%% Astrosyte model
params.dCa = 0.05;
params.dIP3 = 0.05;
params.enter_astro = 8;
params.min_neurons_activity = 12;
params.t_neuro = 0.06;
params.amplitude_neuro = 5;
params.threshold_Ca = 0.15;
window_astro_watch = 0.005; % t(sec)
shift_window_astro_watch = 0.001; % t(sec)
impact_astro = 0.02; % t(sec)
params.impact_astro = fix(impact_astro / params.step);
params.window_astro_watch = fix(window_astro_watch / params.step);
params.shift_window_astro_watch = fix(shift_window_astro_watch / params.step);
t_comp_memory = 0.03;
params.t_comp_memory = fix(t_comp_memory / params.step);

params_p = params;
end