function [Iapp, t_Iapp_met, Im, Im_noise] = make_Iapp(t_Iapp, is_pre_training)
params = model_parameters();

images1 = load_images();
images = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns, 'int8');
for i = 1 : params.N_patterns
    images(:,:,i) = images1{1,i} < params.threshold_pic;
end
images = images(:,:, randperm(size(images,3)));

if is_pre_training
    [Iapp, t_Iapp_met, Im, Im_noise] = pre_training(t_Iapp, images);
else
    [Iapp, t_Iapp_met, Im, Im_noise] = test(t_Iapp, images);
end

%% pre-training
    function [Iapp, t_Iapp_met, Im, Im_noise] = pre_training(t_Iapp, images)
        Images = images(:,:,1 : params.N_patterns);
        Iapp = zeros(params.mneuro_E, params.nneuro_E, (params.N_patterns * params.N_present), 'int8');
        
        for i = 1 : params.N_patterns
            for k = 1 : params.N_present
                Image1 = Images(:,:,i);
                Iapp(:,:,(k +(i - 1) * params.N_present)) = Image1 .* params.Iapp_training;
            end
        end
        
        t_Iapp_met = zeros(1, params.n_pre_training, 'int32');
        for i = 1 : size(Iapp, 3)
            t_Iapp_met(t_Iapp(i, 1) : t_Iapp(i, 2)) = i;
        end
        Im = Iapp;
        Im_noise = Iapp;
    end

%% Test
    function[Iapp, t_Iapp_met, Im, Im_noise] = test(t_Iapp, images)
        Images = images(:,:, 1 : params.N_patterns_1_cycle);
        Im_new = images(:,:, params.N_patterns_1_cycle + 1 : params.N_patterns_1_cycle + params.N_cycles);
        
        Im = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns_1_cycle * params.N_cycles);
        Im_noise = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns_1_cycle * params.N_cycles);
        
        I = size(t_Iapp, 1);
        Iapp = zeros(params.mneuro_E, params.nneuro_E, I);
        
        %% Initial pull
        for i = 1 : params.N_patterns_1_cycle
            for j = 1 : params.N_present
                Image1 = Images(:,:,i);
                p = randperm(params.quantity_neurons_E);
                ind = p(1 : uint16(params.quantity_neurons_E * params.variance_training));
                Image1(ind)= abs(Image1(ind) - 1);
                Iapp(:,:,(j +(i - 1) * params.N_present)) = Image1 .* params.Iapp_training;
            end
        end
        
        %% Cycles
        k = params.N_patterns_1_cycle * params.N_present + 1;
        for i = 1 : params.N_cycles
            for j = 1 : params.N_present
                Image1 = Im_new(:,:,i);
                p = randperm(params.quantity_neurons_E);
                ind = p(1 : uint16(params.quantity_neurons_E * params.variance_training));
                Image1(ind)= abs(Image1(ind) - 1);
                Iapp(:,:,k) = Image1 .* params.Iapp_training;
                k = k + 1;
            end
            
            for j = 1 : params.N_patterns_1_cycle
                Image1 = Images(:,:,j);
                Im(:,:,(j +(i - 1) * params.N_patterns_1_cycle)) = Image1;
                p = randperm(params.quantity_neurons_E);
                ind = p(1 : uint16(params.quantity_neurons_E * params.variance_test));
                Image1(ind)= abs(Image1(ind) - 1);
                Iapp(:,:,k) = Image1 .* params.Iapp_test;
                Im_noise(:,:,(j +(i - 1) * params.N_patterns_1_cycle)) = Iapp(:,:,k);
                k = k + 1;
                
            end
            Images = Images(:,:,randperm(size(Images,3)));
            Images(:,:,1) = Im_new(:,:,i);
            Images = Images(:,:,randperm(size(Images,3)));
        end
        
        t_Iapp_met = zeros(1, params.n_test, 'int16');
        for i = 1 : size(Iapp, 3)
            t_Iapp_met(t_Iapp(i, 1) : t_Iapp(i, 2)) = i;
        end
    end
end