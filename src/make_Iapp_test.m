function [Iapp, t_Iapp_met, Im, Im_noise] = make_Iapp_test(t_Iapp)
params = model_parameters();

images1 = load_images();
images = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns, 'int8');
for i = 1 : params.N_patterns
    images(:,:,i) = images1{1,i} < 127;
end
images = images(:,:, randperm(size(images,3)));

Images = images(:,:, 1 : params.N_patterns_1_cycle);
Im_new = images(:,:, params.N_patterns_1_cycle + 1 : params.N_patterns_1_cycle + params.N_cycles);

Im = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns_1_cycle * params.N_cycles);
Im_noise = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns_1_cycle * params.N_cycles);

I = size(t_Iapp, 1);
Iapp = zeros(params.mneuro_E, params.nneuro_E, I);

%% Initial pull
k = 1;
for i = 1 : params.N_patterns_1_cycle
    for j = 1 : params.N_present
        Image1 = Images(:,:,i);
        p = randperm(params.quantity_neurons_E);
        b = p(1 : uint16(params.quantity_neurons_E * params.variance_training));
        Image1(b)= abs(Image1(b) - 1);
        Iapp(:,:,k) = Image1 .* params.Iapp_training;
        k = k + 1;
    end
end

%% Cycles
a = 1;
m = 1;
for i = 1 : params.N_cycles
    for j = 1 : params.N_present
        Image1 = Im_new(:,:,m);
        p = randperm(params.quantity_neurons_E);
        b = p(1 : uint16(params.quantity_neurons_E * params.variance_training));
        Image1(b)= abs(Image1(b) - 1);
        Iapp(:,:,k) = Image1 .* params.Iapp_training;
        k = k + 1;
    end
    
    for j = 1 : params.N_patterns_1_cycle
        Image1 = Images(:,:,j);
        Im(:,:,a) = Image1;
        p = randperm(params.quantity_neurons_E);
        b = p(1 : uint16(params.quantity_neurons_E * params.variance_test));
        Image1(b)= abs(Image1(b) - 1);
        Iapp(:,:,k) = Image1 .* params.Iapp_test;
        Im_noise(:,:,a) = Iapp(:,:,k);
        a = a + 1;
        k = k + 1;
        
    end
    Images = Images(:,:,randperm(size(Images,3)));
    Images(:,:,1) = Im_new(:,:,m);
    Images = Images(:,:,randperm(size(Images,3)));
    m = m + 1;
end

t_Iapp_met = zeros(1, params.n_test, 'int16');
for i = 1 : size(Iapp, 3)
    t_Iapp_met(t_Iapp(i, 1) : t_Iapp(i, 2)) = i;
end
end