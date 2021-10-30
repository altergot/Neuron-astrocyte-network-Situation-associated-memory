function [FREQ, Accuracy, Im_noise] = ...
    compute_memory_performance(Im,Im_noise, V, T_Iapp_test)
params = model_parameters();
num_test_patterns = params.N_patterns_1_cycle * params.N_cycles;

%% Number of spikes in tests
V_test = zeros(num_test_patterns, params.quantity_neurons_E, params.t_comp_memory, 'double');
for i = 1 : num_test_patterns
    V_test(i,:,:) = V(:, T_Iapp_test(i,1): T_Iapp_test(i,1) + params.t_comp_memory - 1);
end
Freq = zeros(params.quantity_neurons_E, num_test_patterns, 'int8');
for i = 1 : params.quantity_neurons_E
    for j = 1 : num_test_patterns
        Spike = find(V_test(j,i,1 : end) >= params.neuron_fired_thr);
        Freq(i,j) = length(Spike);
    end
end
Freq = reshape(Freq, params.mneuro_E, params.nneuro_E, []);
FREQ = zeros(params.mneuro_E, params.nneuro_E, num_test_patterns, 'logical');
FREQ(Freq > params.threshold_freq_pic) = 1;

%% Accuracy
FREQ_threshold = zeros(params.mneuro_E, params.nneuro_E, num_test_patterns, 'int8');
FREQ_threshold(Freq > params.threshold_freq) = 1;
Accuracy_every_pattern = zeros(num_test_patterns, 1, 'double');
for k = 1 : num_test_patterns
    FREQ_threshold_1_pattern = FREQ_threshold(:,:,k);
    Image = Im(:,:,k);
    Image = Image(:);
    background = sum(Image == 0);
    pattern = sum(Image == 1);
    FREQ_threshold_1_pattern = FREQ_threshold_1_pattern(:);
    n_true_background = 0;
    n_true_pattern = 0;
    for j = 1 : params.quantity_neurons_E
        if (Image(j) == 0) && (FREQ_threshold_1_pattern(j, 1) == 0)
            n_true_background = n_true_background + 1;
        end
        if (Image(j) == 1) && (FREQ_threshold_1_pattern(j, 1) == 1)
            n_true_pattern = n_true_pattern + 1;
        end
    end
    Accuracy_every_pattern(k, 1) = (n_true_background / background + ...
        n_true_pattern / pattern) / 2;
end
Accuracy = sum(Accuracy_every_pattern) / num_test_patterns;
end