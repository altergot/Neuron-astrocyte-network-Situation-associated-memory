function [model, model_connections] = init_model(is_pre_training, model_connections)
model = struct;
params = model_parameters();
if is_pre_training
    model.T = 0 : params.step : params.t_end_pre_training;
else
    model.T = 0 : params.step : params.t_end_test_cycle;
end
model.T = single(model.T);

%% Synaptic connections
if is_pre_training
    model_connections.Pre_EE  = zeros(1, params.quantity_connections_EE, 'int8');
    model_connections.Post_EE = zeros(1, params.quantity_connections_EE, 'int8');
    model_connections.Pre_EI  = zeros(1, params.quantity_connections_EI, 'int8');
    model_connections.Post_EI = zeros(1, params.quantity_connections_EI, 'int8');
    model_connections.Pre_IE  = zeros(1, params.quantity_connections_IE, 'int8');
    model_connections.Post_IE = zeros(1, params.quantity_connections_IE, 'int8');
    model_connections.W_EE = zeros(params.quantity_connections_EE, 1, 'single');
    model_connections.W_EI = zeros(params.quantity_connections_EI, 1, 'single');
    model_connections.W_EE(:,1) = params.W_EE_0;
    model_connections.W_EI(:,1) = params.W_EI_0;
end
model.is_active = zeros(params.quantity_neurons_E, 1, 'double');
%% Neurons
model.V_line_E = zeros(params.quantity_neurons_E, 1, 'double');
if ~is_pre_training
    model.V_line_E_full = zeros(params.quantity_neurons_E, params.n_test, 'double');
end
model.V_line_I = zeros(params.quantity_neurons_I, 1, 'double');
model.V_line_E(:, 1) = params.v_0;
model.V_line_I(:, 1) = params.v_0;
model.G = zeros(params.quantity_neurons_E, 1, 'double');
model.U_line_E = zeros(params.quantity_neurons_E, 1, 'double');
model.U_line_I = zeros(params.quantity_neurons_I, 1, 'double');
model.Isyn_line_EE = zeros(params.quantity_neurons_E, 1,'double');
model.Isyn_line_EI = zeros(params.quantity_neurons_E, 1,'double');
model.Isyn_line_IE = zeros(params.quantity_neurons_I, 1,'double');
model.Iastro_neuron_line = zeros(params.quantity_neurons_E, 1,'logical');

%% Neuron activity
if ~is_pre_training
    model.neuron_astrozone_activity = zeros(params.mastro, params.nastro, 1,'int8');
    model.neuron_astrozone_spikes   = zeros(params.mastro, params.nastro, params.n_test,'int8');
    
    model.Iastro_neuron = zeros(params.mastro, params.nastro, params.n_test, 'logical');
    model.Ineuro = zeros(params.mastro, params.nastro, params.n_test,'int8');
end

%% Astrocytes
if ~is_pre_training
    model.Ca = zeros(params.mastro, params.nastro, 1,'double');
    model.H = zeros(params.mastro, params.nastro, 1,'double');
    model.IP3 = zeros(params.mastro, params.nastro, 1,'double');
    model.Ca(:,:,1) = params.ca_0;
    model.H(:,:,1) = params.h_0;
    model.IP3(:,:,1) = params.ip3_0;
end

%% Iapp
[model.T_Iapp, model.T_Iapp_test] = stimulation_times(is_pre_training);

%% Prepare model
[model.Iapp, model.T_Iapp_met, model.Im, model.Im_noise] = ...
    make_Iapp(model.T_Iapp, is_pre_training);
if is_pre_training
    [model_connections.Pre_EE, model_connections.Post_EE] = ...
        create_connections(1);
    [model_connections.Pre_EI, model_connections.Post_EI] = ...
        create_connections(2);
    [model_connections.Pre_IE, model_connections.Post_IE] = ...
        create_connections(3);
end
end