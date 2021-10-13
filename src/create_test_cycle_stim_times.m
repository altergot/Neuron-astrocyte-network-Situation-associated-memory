function [t_Iapp] = create_test_cycle_stim_times()
params = model_parameters();

t_Iapp = zeros((params.N_patterns_1_cycle + params.N_cycles) * params.N_present ...
    + params.N_patterns_1_cycle + params.N_cycles, 2);
for i = 1 : (params.N_patterns_1_cycle * params.N_present)
    t_Iapp(i,1) = params.t_start_stim + (i - 1) * params.training_impulse_T;
    t_Iapp(i,2) = t_Iapp(i,1) + params.training_impulse_duration;
end
t_Iapp_start_cycle = t_Iapp(i,1) + params.t_pause_test_cycle;

for j = 1 : params.N_cycles
    m = 1;
    for k = 1 : params.N_present
        i = i + 1;
        t_Iapp(i,1) = t_Iapp_start_cycle + (m - 1) * params.training_impulse_T;
        t_Iapp(i,2) = t_Iapp(i,1) + params.training_impulse_duration;
        m = m + 1;
        t_Iapp_start_test = t_Iapp(i,2) + params.test_impulse_T;
    end
    
    m = 1;
    for k = 1 : params.N_patterns_1_cycle
        i = i + 1;
        t_Iapp(i,1) = t_Iapp_start_test + (m - 1) * params.test_impulse_T;
        t_Iapp(i,2) = t_Iapp(i,1) + params.test_impulse_duration;
        m = m + 1;
        t_Iapp_start_cycle = t_Iapp(i,2) + params.test_impulse_T;
    end
end
t_Iapp = fix(t_Iapp ./ params.step);

end