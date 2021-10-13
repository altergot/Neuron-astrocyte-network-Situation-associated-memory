function[Images_Accuracy, thershold_Freq, Accuracy_every_pattern, ...
    Accuracy, Im, Im_noise] = compute_memory_performance(Im,Im_noise, ...
    V, T_Iapp)

params = model_parameters();

num_test_patterns = params.N_patterns_1_cycle * params.N_cycles;
T_Iapp_test = zeros(params.N_patterns_1_cycle * params.N_cycles, 2);

j = 1;
for i = ((params.N_patterns_1_cycle + 1) * params.N_present + 1) : ...
        ((params.N_patterns_1_cycle + 1) * params.N_present + params.N_patterns_1_cycle)
    T_Iapp_test(j,:) = T_Iapp(i,:);
    j = j + 1;
end
for m = 2 : params.N_cycles
    for k = i + params.N_present + 1 : i + params.N_present + params.N_patterns_1_cycle
        T_Iapp_test(j,:) = T_Iapp(k,:);
        j = j + 1;
    end
    i = k;
end

V_test = zeros(num_test_patterns, params.quantity_neurons_E, params.t_comp_memory);
for i = 1 : num_test_patterns
    V_test(i,:,:) = V(:, T_Iapp_test(i,1): T_Iapp_test(i,1) + params.t_comp_memory - 1);
end

Freq = zeros(params.quantity_neurons_E, num_test_patterns);
for i = 1 : params.quantity_neurons_E
    for j = 1 : num_test_patterns
        Spike = find(V_test(j,i,1 : end) > 29);
        Freq(i,j) = length(Spike);
    end
end
FREQ = reshape(Freq, params.mneuro_E, params.nneuro_E, []);

for i = 2 : 3
    theshold = i;
    FREQ_thesh = zeros(params.mneuro_E, params.nneuro_E, num_test_patterns);
    FREQ_thesh(FREQ > theshold) = 1;
    accur = zeros(num_test_patterns, 1);
    
    for k = 1 : num_test_patterns
        FREQ_thesh1 = FREQ_thesh(:,:,k);
        Image = Im(:,:,k);
        Image_line = Image(:);
        background = sum(Image_line == 0);
        pattern = sum(Image_line == 1);
        FREQ_thesh_line = FREQ_thesh1(:);
        n_true_background = 0;
        n_true_pattern = 0;
        
        for j = 1 : params.quantity_neurons_E
            if (Image_line(j) == 0) && (FREQ_thesh_line(j, 1) == 0)
                n_true_background = n_true_background + 1;
            end
            if (Image_line(j) == 1) && (FREQ_thesh_line(j, 1) == 1)
                n_true_pattern = n_true_pattern + 1;
            end
        end
        accur(k, 1) = (n_true_background / background + n_true_pattern / pattern) / 2;
    end
    if i == 2
        thershold_Freq = theshold;
        Accuracy_every_pattern = accur;
        Accuracy = sum(Accuracy_every_pattern) / num_test_patterns;
    end
    Images_Accuracy = FREQ_thesh;
end
end