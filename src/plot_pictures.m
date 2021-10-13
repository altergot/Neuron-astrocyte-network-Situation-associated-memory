function [Iapp,Freq] = plot_pictures(model)
params = model_parameters();

Iapp = zeros(params.mneuro_E * params.N_cycles, params.nneuro_E * ...
    params.N_patterns_1_cycle);
Freq = zeros(params.mneuro_E * params.N_cycles, params.nneuro_E * ...
    params.N_patterns_1_cycle);
m = 1;
k=1;
for i = 1 : params.N_cycles
    n = 1;
    for j = 1 : params.N_patterns_1_cycle
        Iapp(m : m+params.nneuro_E - 1, n:n+params.nneuro_E - 1) = ...
            model.Iapp_test(:,:,k);
        Freq(m : m+params.nneuro_E - 1, n:n+params.nneuro_E - 1) = ...
            model.Images_Accuracy(:,:,k);
        k = k+1;
        n = n + params.nneuro_E;
    end
    m = m + params.nneuro_E;
end

%% Test
fh1 = figure(1);
fh1.WindowState = 'maximized';
subplot(1,2,1)
imagesc(Iapp);
axis off;
set(gca,'FontSize',20,'fontWeight','bold');
title('Cues');
colormap(gray(5));

subplot(1,2,2)
imagesc(Freq);
axis off;
set(gca,'FontSize',20,'fontWeight','bold');
title('Neurons');

end