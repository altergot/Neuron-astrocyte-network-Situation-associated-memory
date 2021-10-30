function [t_Iapp, t_Iapp_test] =  stimulation_times(is_pre_training)
if is_pre_training
    [t_Iapp, t_Iapp_test] = pre_training_stimulus();
else [t_Iapp, t_Iapp_test] = test_stimulus();
end

    function [t_Iapp, t_Iapp_test] = pre_training_stimulus()
        params = model_parameters();
        
        t_Iapp = zeros(params.N_patterns * params.N_present, 2, 'double');
        for i = 1 : (size(t_Iapp,1))
            t_Iapp(i,1) = params.t_start_stim + (i - 1) * params.training_impulse_T;
            t_Iapp(i,2) = t_Iapp(i,1) + params.training_impulse_duration;
        end
        t_Iapp = fix(t_Iapp ./ params.step);
        t_Iapp_test = 0;
    end

    function [t_Iapp, t_Iapp_test] = test_stimulus()
        params = model_parameters();
        
        t_Iapp = zeros((params.N_patterns_1_cycle + params.N_cycles) * params.N_present ...
            + params.N_patterns_1_cycle + params.N_cycles, 2, 'double');
        t_Iapp_test = zeros(params.N_patterns_1_cycle + params.N_cycles, 2, 'double');
        
        for i = 1 : (params.N_patterns_1_cycle * params.N_present)
            t_Iapp(i,1) = params.t_start_stim + (i - 1) * params.training_impulse_T;
            t_Iapp(i,2) = t_Iapp(i,1) + params.training_impulse_duration;
        end
        t_Iapp_start_cycle = t_Iapp(i,1) + params.t_pause_test_cycle;
        pattern_number = params.N_patterns_1_cycle * params.N_present + 1;
        pattern_test_number = 1;
        
        for j = 1 : params.N_cycles
            
            for k = 1 : params.N_present
                t_Iapp(pattern_number,1) = t_Iapp_start_cycle + (k - 1) * params.training_impulse_T;
                t_Iapp(pattern_number,2) = t_Iapp(pattern_number,1) + params.training_impulse_duration;
                t_Iapp_start_test = t_Iapp(pattern_number,2) + params.test_impulse_T;
                pattern_number = pattern_number + 1;
            end
            
            
            for k = 1 : params.N_patterns_1_cycle
                t_Iapp(pattern_number,1) = t_Iapp_start_test + (k - 1) * params.test_impulse_T;
                t_Iapp(pattern_number,2) = t_Iapp(pattern_number,1) + params.test_impulse_duration;
                
                t_Iapp_test(pattern_test_number,:) = t_Iapp(pattern_number,:);
                t_Iapp_start_cycle = t_Iapp(pattern_number,2) + params.test_impulse_T;
                pattern_number = pattern_number + 1;
                pattern_test_number = pattern_test_number + 1;
            end
        end
        t_Iapp = fix(t_Iapp ./ params.step);
        t_Iapp_test = fix(t_Iapp_test ./ params.step);
    end
end