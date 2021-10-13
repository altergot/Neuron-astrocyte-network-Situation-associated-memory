function [Iapp, t_Iapp_met] = make_Iapp_training(t_Iapp)
params = model_parameters();

images1 = load_images();
images = zeros(params.mneuro_E, params.nneuro_E, params.N_patterns, 'int8');
for i = 1 : params.N_patterns
    images(:,:,i) = images1{1,i} < 127;
end
images = images(:,:,randperm(size(images,3)));
Images = images(:,:,1 : params.N_patterns);
Iapp = zeros(params.mneuro_E, params.nneuro_E, (params.N_patterns * params.N_present));

j = 1;
for i = 1 : params.N_patterns
    for k = 1 : params.N_present
        Image1 = Images(:,:,i);
        Iapp(:,:,j) = Image1 .* params.Iapp_training;
        j = j + 1;
    end
end

t_Iapp_met = zeros(1, params.n_pre_training);
for i = 1 : size(Iapp, 3)
    t_Iapp_met(t_Iapp(i, 1) : t_Iapp(i, 2)) = i;
end

end