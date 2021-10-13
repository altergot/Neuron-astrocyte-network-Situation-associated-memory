function [t_Iapp] = create_pre_training_stim_times()
params = model_parameters();

t_Iapp = zeros(params.N_patterns * params.N_present, 2);
for i = 1 : (size(t_Iapp,1))
    t_Iapp(i,1) = params.t_start_stim + (i - 1) * params.training_impulse_T;
    t_Iapp(i,2) = t_Iapp(i,1) + params.training_impulse_duration;
end
t_Iapp = fix(t_Iapp ./ params.step);

end