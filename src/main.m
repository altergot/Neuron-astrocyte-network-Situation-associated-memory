try
    tic;
    %% Initialization
    close all; clearvars;
    rng(42);
    params = model_parameters(true);
    
    %% Pre - training
    disp('Pre - training');
    is_pre_training = true;
    model = [];
    [model_pre_training, model] = init_model(is_pre_training, model);
    [model_pre_training, model] = ...
        simulate_model(model_pre_training, params, is_pre_training, model);
    clear model_pre_training
    
    %% Test
    disp('Test');
    is_pre_training = false;
    [model_test, model] = init_model(is_pre_training, model);
    [model_test, model] = ...
        simulate_model(model_test, params, is_pre_training, model);
    
    %% Compute memory performance
    [model.Images_Accuracy, model.Accuracy, model.Iapp_test] = ...
        compute_memory_performance(model_test.Im, model_test.Im_noise, ...
        model_test.V_line_E_full, model_test.T_Iapp_test);
    clear model_test
    toc;
    fprintf('Mean memory performance: %0.4f\n', model.Accuracy);
    [model.Iapp_test,model.Freq_test] = plot_pictures(model);
    
catch ME
    if (strcmp(ME.identifier,'MATLAB:nomem'))
        error('Out of memory. Please, increase the amount of available memory. \nThe minimum required amount of RAM is 16 GB.', 0);
    else
        rethrow(ME);
    end
end